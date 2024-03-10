CREATE TYPE transaction_kind AS ENUM ('credit', 'debit');

CREATE TABLE wallets (
  id SERIAL PRIMARY KEY,
  balance INT DEFAULT 0,
  credit_limit INT DEFAULT 0
);

CREATE TABLE transactions (
  id SERIAL PRIMARY KEY,
  wallet_id INT REFERENCES wallets(id) NOT NULL,
  value INT NOT NULL,
  kind transaction_kind NOT NULL,
  description VARCHAR(10) NOT NULL CHECK (description <> ''),
  inserted_at TIMESTAMP with time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX transactions_wallet_id_index ON transactions (wallet_id);

CREATE INDEX transactions_inserted_at_index ON transactions (inserted_at);

INSERT INTO
  wallets (id, balance, credit_limit)
VALUES
  (1, 0, 100000),
  (2, 0, 80000),
  (3, 0, 1000000),
  (4, 0, 10000000),
  (5, 0, 500000);

ALTER TABLE "wallets" ADD CONSTRAINT "positive_balance" CHECK ("credit_limit" + "balance" >= 0);