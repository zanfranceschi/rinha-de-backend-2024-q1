DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS clients CASCADE;

CREATE UNLOGGED TABLE IF NOT EXISTS clients (
  id SERIAL PRIMARY KEY,
  account_limit INT NOT NULL,
  balance INT NOT NULL DEFAULT 0
);

CREATE UNLOGGED TABLE IF NOT EXISTS transactions (
  id SERIAL PRIMARY KEY,
  amount INT NOT NULL,
  type CHAR(1) NOT NULL,
  description VARCHAR(10) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
  client_id INT NOT NULL REFERENCES clients(id)
);

CREATE INDEX transactions_created_at_index ON transactions(client_id, created_at DESC);

DO $$
  BEGIN
    INSERT INTO clients (account_limit)
    VALUES
      (100000),
      (80000),
      (1000000),
      (10000000),
      (500000);
  END;
$$;
