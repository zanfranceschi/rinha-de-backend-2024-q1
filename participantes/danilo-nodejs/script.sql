CREATE TABLE IF NOT EXISTS clients (
  id SERIAL PRIMARY KEY,
  limit_use INTEGER,
  balance INTEGER,
  CONSTRAINT verificar CHECK (balance >= (-limit_use))
);

INSERT INTO clients (id, limit_use, balance)
SELECT 1, 100000, 0
WHERE NOT EXISTS (
  SELECT 1 FROM clients WHERE id = 1
);

INSERT INTO clients (id, limit_use, balance)
SELECT 2, 80000, 0
WHERE NOT EXISTS (
  SELECT 1 FROM clients WHERE id = 2
);

INSERT INTO clients (id, limit_use, balance)
SELECT 3, 1000000, 0
WHERE NOT EXISTS (
  SELECT 1 FROM clients WHERE id = 3
);

INSERT INTO clients (id, limit_use, balance)
SELECT 4, 10000000, 0
WHERE NOT EXISTS (
  SELECT 1 FROM clients WHERE id = 4
);

INSERT INTO clients (id, limit_use, balance)
SELECT 5, 500000, 0
WHERE NOT EXISTS (
  SELECT 1 FROM clients WHERE id = 5
);


CREATE TABLE IF NOT EXISTS transactions (
  id BIGSERIAL PRIMARY KEY,
  id_client INTEGER NOT NULL,
  credit_debit char(1) NOT NULL,
  amount INTEGER NOT NULL DEFAULT 0,
  description VARCHAR(10),
  created_at timestamp default current_timestamp
);

CREATE INDEX IF NOT EXISTS transactions_created_at_idx ON transactions USING btree (created_at DESC, id_client);
