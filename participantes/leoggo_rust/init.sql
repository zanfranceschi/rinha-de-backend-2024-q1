CREATE TABLE IF NOT EXISTS clientes (
  id INTEGER,
  limite INTEGER,
  saldo INTEGER
);

CREATE TABLE IF NOT EXISTS transacoes (
  valor INTEGER,
  tipo TEXT,
  descricao TEXT,
  momento TIMESTAMPTZ DEFAULT NOW(),
  id INTEGER
);

INSERT INTO clientes (id, limite, saldo)
VALUES 
  (1, 100000, 0),
  (2, 80000, 0),
  (3, 1000000, 0),
  (4, 10000000, 0),
  (5, 500000, 0)
;