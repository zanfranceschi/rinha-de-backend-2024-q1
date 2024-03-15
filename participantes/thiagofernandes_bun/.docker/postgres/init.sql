DROP TABLE IF EXISTS clientes;

CREATE TABLE clientes (
  id SERIAL PRIMARY KEY,
  limite INT NOT NULL,
  saldo INT DEFAULT 0 NOT NULL,
  transacoes TEXT NOT NULL DEFAULT '[]'
);

CREATE UNIQUE INDEX idx_clientes_id ON clientes USING btree (id);

INSERT INTO clientes (limite) VALUES
  (1000 * 100),
  (800 * 100),
  (10000 * 100),
  (100000 * 100),
  (5000 * 100);