-- name: GetCustomer :one
SELECT * FROM clientes
WHERE id = $1 LIMIT 1;

-- name: UpdateCustomer :many
UPDATE clientes
  set saldo = saldo + $2
WHERE id = $1
RETURNING *;

-- name: InsertTransaction :exec
INSERT INTO transacoes (
  cliente_id, valor, tipo, descricao
) VALUES (
  $1, $2, $3, $4
);

-- name: GetLastTransactions :many
SELECT valor, tipo, descricao, realizada_em FROM transacoes
WHERE cliente_id = $1 ORDER BY id DESC LIMIT 10;
