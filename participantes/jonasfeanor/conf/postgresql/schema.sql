CREATE UNLOGGED TABLE clients (
    id SERIAL PRIMARY KEY,
    balance INTEGER NOT NULL DEFAULT 0,
    credit_limit INTEGER NOT NULL DEFAULT 0
);

ALTER TABLE
    clients DISABLE ROW LEVEL SECURITY;

CREATE UNLOGGED TABLE transactions (
    id SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL,
    amount INTEGER NOT NULL,
    transaction_type VARCHAR(1) NOT NULL,
    description VARCHAR(10) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
    CONSTRAINT fk_transactions_client_id FOREIGN KEY (client_id) REFERENCES clients (id)
);

ALTER TABLE
    transactions DISABLE ROW LEVEL SECURITY;

ALTER TABLE
    transactions
SET
    (autovacuum_enabled = FALSE);

CREATE INDEX IF NOT EXISTS transactions_created_at_idx ON transactions(created_at DESC);

---
DO $$ BEGIN
    INSERT INTO
        clients (id, credit_limit, balance)
    VALUES
        (1, 100000, 0),
        (2, 80000, 0),
        (3, 1000000, 0),
        (4, 10000000, 0),
        (5, 500000, 0);

END;

$$