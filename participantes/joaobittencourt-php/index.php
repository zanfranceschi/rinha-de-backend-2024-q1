<?php

declare(strict_types=1);

$method = $_SERVER['REQUEST_METHOD'] ?: null;
$requestUri = $_SERVER['REQUEST_URI'] ?: null;
$id = substr($requestUri, 10, 1) ?: null;

if (is_null($method) || is_null($requestUri) || !is_numeric($id)) {
    http_response_code(404);
    return;
}

function connectToDB(): \PDO
{
    $connection = new \PDO(
        'pgsql:host=localhost;port=5432;dbname=rinha',
        'rinha',
        'rinha',
        [
            \PDO::ATTR_PERSISTENT => true
        ]
    );
    return $connection;
}


function createTransaction($clienteId, array $requestData)
{
    if (
        !is_numeric($clienteId) ||
        empty($requestData['valor']) || !is_int($requestData['valor']) || $requestData['valor'] < 0 ||
        empty($requestData['tipo']) || !in_array($requestData['tipo'], ['c', 'd']) ||
        empty($requestData['descricao']) || mb_strlen($requestData['descricao']) < 1 || mb_strlen($requestData['descricao']) > 10
    ) {
        http_response_code(422);
        exit;
    }

    $connection = connectToDB();

    $begin = $connection->prepare('BEGIN;');
    $begin->execute();

    $cliente =  $connection->prepare("SELECT limite, saldo FROM clientes WHERE id = $clienteId FOR UPDATE;");
    $cliente->execute();
    $clienteResult = $cliente->fetch(\PDO::FETCH_OBJ);

    $saldo =  $clienteResult->saldo;
    $limite =  $clienteResult->limite;

    $saldoTemp = $saldo + ($requestData['tipo'] == 'd' ? $requestData['valor'] * -1 : $requestData['valor']);

    if ($saldoTemp < $limite * -1) {
        $rollback = $connection->prepare('ROLLBACK;');
        $rollback->execute();

        http_response_code(422);
        exit;
    }

    $query = $connection->prepare('INSERT INTO transacoes (cliente_id, valor, tipo, descricao, realizada_em) 
    VALUES (:cliente_id, :valor, :tipo, :descricao, :realizada_em);');

    $query->bindParam(':cliente_id', $clienteId, \PDO::PARAM_INT);
    $query->bindParam(':valor', $requestData['valor'], \PDO::PARAM_INT);
    $query->bindParam(':tipo', $requestData['tipo'], \PDO::PARAM_STR);
    $query->bindParam(':descricao', $requestData['descricao'], \PDO::PARAM_STR);
    $query->bindParam(':realizada_em', (new DateTime('now'))->format("Y-m-d\TH:i:s.u\Z"), \PDO::PARAM_STR);
    $query->execute();

    $updateCliente = $connection->prepare("UPDATE clientes SET saldo = $saldoTemp WHERE id = $clienteId;");
    $updateCliente->execute();

    $commit = $connection->prepare('COMMIT;');
    $commit->execute();

    http_response_code(200);
    header('Content-Type:application/json');

    echo '{
        "limite" : ' . $limite . ',
        "saldo" : ' . $saldoTemp . '
    }';
    exit;
}

function getExtrato(int $clienteId)
{

    $connection = connectToDB();

    $begin = $connection->prepare('BEGIN;');
    $begin->execute();

    $cliente = $connection->prepare('SELECT saldo, limite FROM clientes WHERE clientes.id = :cliente_id LIMIT 1 FOR UPDATE;');
    $cliente->bindParam(':cliente_id', $clienteId);

    $cliente->execute();

    $clienteResult = $cliente->fetch(\PDO::FETCH_OBJ);

    $query = $connection->prepare("SELECT 
            transacoes.valor,
            transacoes.tipo,
            transacoes.descricao,
            transacoes.realizada_em
        FROM
            transacoes 
        WHERE
            transacoes.cliente_id = {$clienteId}
        ORDER BY 
            transacoes.id DESC
        LIMIT 
            10;
    ");

    $query->execute();

    $result = $query->fetchAll(\PDO::FETCH_OBJ);
    $results = is_bool($result) ? [] : $result;

    $commit = $connection->prepare('COMMIT;');
    $commit->execute();

    $ultimasTransacoes = [];
    foreach ($results as $data) {
        $ultimasTransacoes[] = [
            'valor' => $data->valor,
            'tipo' => $data->tipo,
            'descricao' => $data->descricao,
            'realizada_em' => $data->realizada_em
        ];
    }

    $json = [
        'saldo' => [
            'total' => $clienteResult->saldo,
            'data_extrato' => (new DateTime('now'))->format("Y-m-d\TH:i:s.u\Z"),
            'limite' => $clienteResult->limite,
        ],
        'ultimas_transacoes' => $ultimasTransacoes
    ];

    http_response_code(200);
    header('Content-Type:application/json');
    echo json_encode($json);
    exit;
}

if ($method === 'POST' && preg_match('/\/clientes\/[1-5]{1}\/transacoes/', $requestUri)) {
    createTransaction($id, json_decode(file_get_contents('php://input'), true));
} elseif ($method === 'GET' && preg_match('/\/clientes\/[1-5]{1}\/extrato/', $requestUri)) {
    getExtrato((int) $id);
}

http_response_code(404);
exit;