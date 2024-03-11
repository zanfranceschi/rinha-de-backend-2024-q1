CREATE UNLOGGED TABLE clients (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  credit_limit INTEGER NOT NULL,
  balance INTEGER NOT NULL DEFAULT 0
);

CREATE UNLOGGED TABLE transactions (
  id SERIAL PRIMARY KEY,
  client_id INTEGER NOT NULL,
  value INTEGER NOT NULL,
  type CHAR(1) NOT NULL,
  description VARCHAR(10) NOT NULL,
  transaction_at TIMESTAMP   NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    CONSTRAINT fk_transacoes_client_id
    FOREIGN KEY (client_id) REFERENCES clients(id)
);

CREATE INDEX idx_client_id ON transactions(client_id, transaction_at);

DO $$
BEGIN
  INSERT INTO clients (name, credit_limit)
  VALUES
    ('o barato sai caro', 1000 * 100),
    ('zan corp ltda', 800 * 100),
    ('les cruders', 10000 * 100),
    ('padaria joia de cocaia', 100000 * 100),
    ('kid mais', 5000 * 100);
END; $$
