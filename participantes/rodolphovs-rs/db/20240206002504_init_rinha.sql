-- Add migration script here

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  balance_limit INT NOT NULL,
  balance INT DEFAULT 0 NOT NULL,
  transactions_count INT DEFAULT 0 NOT NULL,
  last_transaction INT DEFAULT 0 NOT NULL,
  encoded_transactions BYTEA NULL
);

INSERT INTO users (balance_limit) VALUES (100000);
INSERT INTO users (balance_limit) VALUES (80000);
INSERT INTO users (balance_limit) VALUES (1000000);
INSERT INTO users (balance_limit) VALUES (10000000);
INSERT INTO users (balance_limit) VALUES (500000);
