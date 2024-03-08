CREATE TABLE clientes (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  limite INTEGER NOT NULL,
  saldo INTEGER DEFAULT 0
);
CREATE TABLE transacoes (
  id SERIAL PRIMARY KEY,
  valor INTEGER,
  tipo CHAR(1) CHECK (type IN ('c', 'd')),
  descricao VARCHAR(10),
  cliente_id INTEGER REFERENCES clientes(id),
  realizado_em VARCHAR(27)
);
INSERT INTO clientes (nome, limite, saldo)
  VALUES
    ('o barato sai caro', 1000 * 100, 0),
    ('zan corp ltda', 800 * 100, 0),
    ('les cruders', 10000 * 100, 0),
    ('padaria joia de cocaia', 100000 * 100, 0),
    ('kid mais', 5000 * 100, 0);