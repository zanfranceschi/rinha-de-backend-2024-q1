CREATE UNLOGGED TABLE clientes (
  id INTEGER PRIMARY KEY,
  saldo INTEGER NOT NULL DEFAULT 0);

CREATE UNLOGGED TABLE transacoes (
  id SERIAL PRIMARY KEY,
  cliente_id INTEGER NOT NULL,
  valor INTEGER NOT NULL,
  tipo CHAR(1) NOT NULL DEFAULT 'd',
  descricao VARCHAR(10) NOT NULL);

CREATE INDEX transacoes_cliente_id ON transacoes (cliente_id);

CREATE OR REPLACE FUNCTION crebitar_d(
  cliente_id_input INTEGER,
  valor_input INTEGER,
  descricao_input VARCHAR(10),
  limite INTEGER) 
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
  atual INTEGER;
BEGIN
  PERFORM pg_advisory_xact_lock(cliente_id_input);
  SELECT c.saldo
  INTO atual
  FROM clientes c
  WHERE c.id = cliente_id_input;

  IF atual - valor_input < limite THEN
    RETURN NULL;
  END IF;

  atual := atual - valor_input;
  
  INSERT INTO transacoes (cliente_id, valor, descricao) VALUES (cliente_id_input, valor_input, descricao_input);
  UPDATE clientes SET saldo = atual WHERE id = cliente_id_input;
  
  RETURN atual;
END;
$$;

CREATE OR REPLACE FUNCTION crebitar_c(
  cliente_id_input INTEGER,
  valor_input INTEGER,
  descricao_input VARCHAR(10),
  limite INTEGER)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
  atual INTEGER;
BEGIN
  PERFORM pg_advisory_xact_lock(cliente_id_input);

  INSERT INTO transacoes (cliente_id, valor, tipo, descricao) VALUES (cliente_id_input, valor_input, 'c', descricao_input);
  UPDATE clientes SET saldo = saldo + valor_input WHERE id = cliente_id_input RETURNING saldo INTO atual;

  RETURN atual;
END;
$$;

CREATE OR REPLACE FUNCTION extrato(cliente_id_input INTEGER)
  RETURNS TABLE (valor_out INTEGER, tipo_out CHAR(1), descricao_out VARCHAR(10)) AS
$body$
BEGIN
  RETURN QUERY (
    (SELECT c.saldo, 'x' AS tipo, '' AS descricao
     FROM clientes AS c
     WHERE c.id=$1)
    UNION ALL
    (SELECT t.valor, t.tipo, t.descricao
     FROM transacoes AS t
     WHERE t.cliente_id=$1
     ORDER BY id DESC
     LIMIT 10)
  );
END;
$body$
LANGUAGE plpgsql
  ROWS 11;