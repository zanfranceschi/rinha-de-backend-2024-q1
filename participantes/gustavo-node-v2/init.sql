CREATE TABLE clientes (
  id SERIAL PRIMARY KEY NOT NULL,
  nome VARCHAR(23) NOT NULL, 
  limite INTEGER NOT NULL CHECK (limite >= 0),
  saldo INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE transacoes (
  id SERIAL PRIMARY KEY NOT NULL,
  id_cliente INTEGER NOT NULL,
  valor INTEGER NOT NULL,
  tipo CHAR(1) NOT NULL,
  descricao VARCHAR(10),
  realizada_em TIMESTAMP WITH TIME ZONE NOT NULL,

  CONSTRAINT clientes FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);

DO $$
BEGIN
  INSERT INTO clientes (nome, limite)
  VALUES
    ('o barato sai caro', 1000 * 100),
    ('zan corp ltda', 800 * 100),
    ('les cruders', 10000 * 100),
    ('padaria joia de cocaia', 100000 * 100),
    ('kid mais', 5000 * 100);
END; $$
