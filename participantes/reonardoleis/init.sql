CREATE DATABASE banky;

\c banky;

CREATE UNLOGGED TABLE accounts(
  id BIGSERIAL PRIMARY KEY,
  initial_balance BIGINT NOT NULL,
  "limit" BIGINT NOT NULL
);

CREATE UNLOGGED TABLE transactions(
  id BIGSERIAL PRIMARY KEY,
  type VARCHAR(1) NOT NULL,
  amount BIGINT NOT NULL,
  description TEXT NOT NULL,
  created_at TIMESTAMPTZ,
  account_id BIGINT NOT NULL,
  status INT NOT NULL DEFAULT '0',
  FOREIGN KEY (account_id) REFERENCES accounts(id)
  ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO accounts (id, initial_balance, "limit")
VALUES 
    (1, 0, 100000),
    (2, 0, 80000),
    (3, 0, 1000000),
    (4, 0, 10000000),
    (5, 0, 500000);