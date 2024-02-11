CREATE TABLE clients (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  mov_limit INTEGER NOT NULL
);

CREATE TYPE transaction_type AS ENUM ('credit', 'debit');

CREATE TABLE transactions (
  id SERIAL PRIMARY KEY,
  client_id INTEGER REFERENCES clients,
  value INTEGER NOT NULL,
  type transaction_type NOT NULL,
  description VARCHAR(10) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_client_id_transactions ON transactions (client_id);

CREATE TABLE balances (
  id SERIAL PRIMARY KEY,
  client_id INTEGER REFERENCES clients,
  value INTEGER NOT NULL
);

CREATE INDEX idx_client_id_balances ON balances (client_id);

DO $$
BEGIN
  INSERT INTO clients (name, mov_limit)
  VALUES
      ('naruto', 100000),
      ('mob', 80000),
      ('jojo', 1000000),
      ('hellboy', 10000000),
      ('ultramega', 500000);
  INSERT INTO balances (client_id, value)
      SELECT id, 0 FROM clients;
END;
$$
