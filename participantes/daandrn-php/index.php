<?php declare(strict_types=1);

define("TIME_STAMP", "Y-m-d\TH:i:s.u\Z");
function exit404() {http_response_code(404);exit;}
function exit422() {http_response_code(422);exit;}

$url = explode("/", $_SERVER["REQUEST_URI"]);
$id = $url[1] === "clientes" && is_numeric($url[2]) ? (int) $url[2] : exit404();

switch (true) {
    case $_SERVER['REQUEST_METHOD'] === "POST" && $url[3] === "transacoes":
        $requestJson = file_get_contents('php://input');
        $request = json_decode($requestJson, false);

        if (!is_int($request->valor)
            || ($request->tipo !== "d" && $request->tipo !== "c") 
            || !is_string($request->descricao) 
            || strlen($request->descricao) < 1 
            || strlen($request->descricao) > 10
        ) {
            exit422();
        }
        
        $conn = pg_pconnect("host=db port=5432 dbname=rinha user=rinha password=456");
        pg_query($conn, "BEGIN");
        $result = pg_query($conn, "SELECT limite, valor AS saldo FROM clientes WHERE id = $id FOR UPDATE;");
        
        if (pg_num_rows($result) < 1) {
            pg_query($conn, "ROLLBACK;");
            exit404();
        }
        
        $client = pg_fetch_object($result);

        switch ($variable) {
            case $request->tipo === "c":
                $novoSaldo = (int) $client->saldo - $request->valor;
                break;
            case $request->tipo === "d":
                $novoSaldo = (int) $client->saldo + $request->valor;
                break;
        }
        
        if ($novoSaldo < -$client->limite) {
            pg_query($conn, "ROLLBACK;");
            exit422();
        }
        
        $quando = new DateTime('now');
        $quando = $quando->format(TIME_STAMP);
        
        $query = 
        "INSERT INTO transacao (cliente_id, valor, tipo, descricao, quando) 
        VALUES ($id, $request->valor, '{$request->tipo}', '{$request->descricao}', '{$quando}');
        
        UPDATE clientes 
        SET valor = $novoSaldo
        WHERE id = $id";

        pg_query($conn, $query);
        pg_query($conn, "COMMIT;");
        
        echo json_encode([
            "limite" => $client->limite,
            "saldo" => $novoSaldo
        ]);
        break;
    case $_SERVER['REQUEST_METHOD'] === "GET" && $url[3] === "extrato":
        $conn = pg_pconnect("host=db port=5432 dbname=rinha user=rinha password=456");
        pg_query($conn, "BEGIN;");
        $result = pg_query($conn, "SELECT valor, limite, (SELECT count(*) FROM transacao) AS quantidade FROM clientes WHERE id = $id LIMIT 1;");
        
        if (pg_num_rows($result) < 1) {
            pg_query($conn, "ROLLBACK;");
            exit404();
        }
        
        $result2 = pg_query($conn, "SELECT valor, tipo, descricao, quando AS realizada_em FROM transacao WHERE cliente_id = $id ORDER BY quando DESC LIMIT 10;");
        $date = new DateTime('now');
        $client = pg_fetch_object($result);
        $transactions = pg_fetch_all($result2);
        !$client->quantidade > 200 ?: pg_query($conn, "DELETE FROM transacao WHERE id NOT IN (SELECT id FROM transacao ORDER BY quando DESC LIMIT 200);");
        pg_query($conn, "COMMIT;");
        array_walk($transactions, function (&$value, $key) {
            if ($key === $key) {
                $value["valor"] = (int) $value["valor"];
            }
        });
        
        echo json_encode([
            "saldo" => [
                "total" => (int) $client->valor, 
                "data_extrato" => $date->format(TIME_STAMP),
                "limite" => (int) $client->limite
            ],
            "ultimas_transacoes" => $transactions
        ]);
        break;
    default:
        exit404();
        break;
}