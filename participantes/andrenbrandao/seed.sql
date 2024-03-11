BEGIN;
DROP TABLE IF EXISTS accounts CASCADE;

CREATE TABLE IF NOT EXISTS accounts (
  id SERIAL NOT NULL,
  name VARCHAR NOT NULL,
  balance INTEGER DEFAULT 0 NOT NULL,
  balance_limit INTEGER DEFAULT 0 NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  PRIMARY KEY(id)
);

INSERT INTO accounts
  (name, balance_limit)
VALUES
  ('John Doe', 1000*100),
  ('Jane Doe', 800*100),
  ('Jack Sparrow', 10000*100),
  ('Bruce Wayne', 100000*100),
  ('Scarlett Johansson', 5000*100);

-- Create transactions
DROP TABLE IF EXISTS transactions CASCADE;

CREATE TABLE IF NOT EXISTS transactions (
  id SERIAL NOT NULL,
  account_id INTEGER NOT NULL,
  amount INTEGER NOT NULL,
  type VARCHAR NOT NULL,
  description VARCHAR NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  PRIMARY KEY(id),
  CONSTRAINT fk_account
    FOREIGN KEY(account_id)
      REFERENCES accounts(id)
      ON DELETE CASCADE
);

CREATE INDEX transactions_account_id_created_at_desc_idx ON transactions(account_id, created_at DESC);

COMMIT;
