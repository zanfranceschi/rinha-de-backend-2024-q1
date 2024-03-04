SET timezone TO 'America/Sao_Paulo';

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    "limit" INTEGER NOT NULL,
    balance INTEGER NOT NULL DEFAULT 0
);

INSERT INTO customers ("limit", balance)
VALUES
    (1000 * 100, 0),
    (800 * 100, 0),
    (10000 * 100, 0),
    (100000 * 100, 0),
    (5000 * 100, 0);

CREATE UNLOGGED TABLE transactions (
    id SERIAL PRIMARY KEY,
    customer_id SMALLINT NOT NULL,
    amount INTEGER NOT NULL,
    type CHAR(1) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description VARCHAR(10) NOT NULL
);

ALTER TABLE
  transactions
SET
  (autovacuum_enabled = false);
