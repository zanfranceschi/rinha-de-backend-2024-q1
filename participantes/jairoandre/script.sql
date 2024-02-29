-- Your SQL goes here
CREATE TABLE clients(
  id SERIAL PRIMARY KEY,
  account_limit BIGINT NOT NULL,
  balance BIGINT NOT NULL,
  CONSTRAINT c_balance CHECK ((clients.balance + clients.account_limit) > 0)
);

CREATE TABLE transactions(
  id SERIAL PRIMARY KEY,
  client_id INT NOT NULL,
  amount BIGINT NOT NULL,
  transaction_type VARCHAR(1) NOT NULL,
  details VARCHAR(10) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "fk_clients" FOREIGN KEY ("client_id") REFERENCES "clients" ("id"),
  CONSTRAINT c_details CHECK (transactions.details <> '')
);

CREATE VIEW last_transactions AS SELECT 
    t.id,
    t.client_id,
    t.amount,
    t.transaction_type,
    t.details,
    t.created_at,
    c.balance,
    c.account_limit
FROM (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY client_id ORDER BY created_at DESC) AS row_num
    FROM transactions
) AS t
JOIN clients c ON c.id = t.client_id
WHERE t.row_num <= 10;

INSERT INTO clients (balance, account_limit)
VALUES
  (0, 1000 * 100),
  (0, 800 * 100),
  (0, 10000 * 100),
  (0, 100000 * 100),
  (0, 5000 * 100);
