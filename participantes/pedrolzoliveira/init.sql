
CREATE TYPE tipo_transacao AS ENUM (
  'c',
  'd'
);

CREATE TABLE clientes (
  id SERIAL PRIMARY KEY,
  limite INT NOT NULL DEFAULT 0,
  saldo INT NOT NULL DEFAULT 0 CHECK (saldo >= limite * -1)
);

CREATE TABLE transacoes (
  cliente_id INT REFERENCES clientes (id),
  valor INT NOT NULL,
  descricao VARCHAR(10) NOT NULL CHECK (LENGTH(descricao) >= 1),
  tipo tipo_transacao NOT NULL,
  realizada_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX transacao_realizada_em_idx ON transacoes (realizada_em);

CREATE OR REPLACE FUNCTION create_transacao (cliente_id int, valor int, tipo tipo_transacao, descricao varchar(10))
    RETURNS TABLE (cliente_saldo int, cliente_limite int)
    AS $$
DECLARE
  ajuste_valor int;
BEGIN
  IF tipo = 'd' THEN
    ajuste_valor := valor * - 1;
  ELSE
    ajuste_valor := valor;
  END IF;
  INSERT INTO transacoes (cliente_id, valor, tipo, descricao)
    VALUES(cliente_id, valor, tipo::tipo_transacao, descricao);
  RETURN QUERY
  UPDATE
    clientes
  SET
    saldo = saldo + ajuste_valor
  WHERE
    id = cliente_id
  RETURNING
    saldo,
    limite;
END;
$$
LANGUAGE plpgsql;

DO $$
BEGIN
  INSERT INTO clientes
  (id, limite)
VALUES
  (1, 100000),
  (2, 80000),
  (3, 1000000),
  (4, 10000000),
  (5, 500000);

END;
$$;