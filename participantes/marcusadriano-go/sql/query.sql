-- name: GetUser :one
SELECT id, balance, balance_limit 
FROM users 
WHERE id = $1;

-- name: GetTransactionsByUser :many
SELECT t.description, t.amount, t.created_at, t.ttype
FROM transactions t
WHERE user_id = $1 ORDER BY created_at DESC LIMIT $2;

-- name: CreateTransaction :exec
INSERT INTO transactions 
(user_id, description, amount, ttype) 
VALUES ($1, $2, $3, $4);

-- name: UpdateUserBalance :one
UPDATE users 
SET balance = balance + $1 
WHERE id = $2 RETURNING balance, balance_limit;

