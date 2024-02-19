-- Your SQL goes here
CREATE TABLE clients(
  id INT PRIMARY KEY,
  account_limit BIGINT NOT NULL,
  balance BIGINT NOT NULL
);

CREATE TABLE transactions(
  id SERIAL PRIMARY KEY,
  client_id INT NOT NULL,
  amount BIGINT NOT NULL,
  transaction_type VARCHAR(1) NOT NULL,
  details TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "fk_clients" FOREIGN KEY ("client_id") REFERENCES "clients" ("id")
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

INSERT INTO clients(id, account_limit, balance) 
VALUES (1, 100000, 0);

INSERT INTO clients(id, account_limit, balance) 
VALUES (2, 80000, 0);

INSERT INTO clients(id, account_limit, balance) 
VALUES (3, 1000000, 0);

INSERT INTO clients(id, account_limit, balance) 
VALUES (4, 10000000, 0);

INSERT INTO clients(id, account_limit, balance) 
VALUES (5, 500000, 0);
