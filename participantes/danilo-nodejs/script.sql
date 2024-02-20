CREATE TABLE IF NOT EXISTS clients (
  id SERIAL PRIMARY KEY,
  limit_use INTEGER,
  balance INTEGER,
  CONSTRAINT verificar CHECK (balance >= (-limit_use))
);

CREATE TABLE IF NOT EXISTS transactions (
  id BIGSERIAL PRIMARY KEY,
  id_client INTEGER NOT NULL,
  credit_debit char(1) NOT NULL,
  amount INTEGER NOT NULL DEFAULT 0,
  description VARCHAR(10),
  created_at timestamp default current_timestamp
);

INSERT INTO clients (id, limit_use, balance)
VALUES
  (1, 100000, 0),
  (2, 80000, 0),
  (3, 1000000, 0),
  (4, 10000000, 0),
  (5, 500000, 0);

CREATE INDEX IF NOT EXISTS transactions_created_at_idx ON transactions USING btree (id_client, created_at DESC);

