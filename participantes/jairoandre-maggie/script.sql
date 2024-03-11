-- Your SQL goes here
CREATE TABLE accounts(
  id SERIAL PRIMARY KEY,
  credit BIGINT NOT NULL,
  balance BIGINT NOT NULL
);

CREATE TABLE transactions(
  id SERIAL PRIMARY KEY,
  account_id INT NOT NULL,
  amount BIGINT NOT NULL,
  transaction_type VARCHAR(1) NOT NULL,
  details VARCHAR(10) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "fk_accounts" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id")
);

INSERT INTO accounts (balance, credit)
VALUES
  (0, 1000 * 100),
  (0, 800 * 100),
  (0, 10000 * 100),
  (0, 100000 * 100),
  (0, 5000 * 100);
