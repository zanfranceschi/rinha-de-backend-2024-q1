CREATE SCHEMA api;
CREATE ROLE anon NOLOGIN;
GRANT USAGE ON SCHEMA api TO anon;

CREATE UNLOGGED TABLE api.clientes (
  id SERIAL PRIMARY KEY,
  limite INT NOT NULL DEFAULT 0,
  saldo INT NOT NULL DEFAULT 0 CHECK (saldo >= -limite)
);

CREATE UNLOGGED TABLE api.transacoes (
  cliente_id INT REFERENCES api.clientes (id),
  valor INT NOT NULL,
  descricao VARCHAR(10) NOT NULL,
  tipo CHAR(1) NOT NULL,
  realizada_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX transacao_realizada_em_idx ON api.transacoes (realizada_em);

CREATE OR REPLACE FUNCTION api.create_transacao (cliente_id int, valor int, tipo char(1), descricao varchar(10))
RETURNS JSON
AS $$
DECLARE
  ajuste_valor int;
  novo_saldo int;
  novo_limite int;
  json_result JSON;
BEGIN
  IF tipo = 'd' THEN
    ajuste_valor := -valor;
  ELSE
    ajuste_valor := valor;
  END IF;

  INSERT INTO api.transacoes (cliente_id, valor, tipo, descricao)
    VALUES (cliente_id, valor, tipo, descricao);

  UPDATE api.clientes
  SET saldo = saldo + ajuste_valor
  WHERE id = cliente_id
  RETURNING saldo, limite INTO novo_saldo, novo_limite;

  json_result := json_build_object(
    'saldo', novo_saldo,
    'limite', novo_limite
  );

  RETURN json_result;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE sqlstate 'PGRST' USING
        message = '{"code":"422","message":"limite de saldo excedido"}',
        detail = '{"status":422,"headers":{}}';


END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION api.extrato(p_cliente_id int)
RETURNS JSON
AS $$
DECLARE
  result JSON;
BEGIN
  WITH ultimas_transacoes AS (
    SELECT valor, tipo, descricao, realizada_em
    FROM api.transacoes t
    WHERE cliente_id = p_cliente_id
    ORDER BY realizada_em DESC
    LIMIT 10
  ),
  saldo AS (
    SELECT saldo AS total, NOW() AS data_extrato, limite
    FROM api.clientes c
    WHERE id = p_cliente_id
  )
  SELECT json_build_object(
    'saldo', (SELECT row_to_json(s) FROM saldo s),
    'ultimas_transacoes', (SELECT COALESCE(json_agg(u), '[]') FROM ultimas_transacoes u)
  ) INTO result;
  
  RETURN result;
END;
$$
LANGUAGE PLPGSQL;

GRANT SELECT, UPDATE ON api.clientes TO anon;
GRANT SELECT, INSERT ON api.transacoes TO anon;

DO $$
BEGIN
  INSERT INTO api.clientes
  (id, limite)
VALUES
  (1, 100000),
  (2, 80000),
  (3, 1000000),
  (4, 10000000),
  (5, 500000);

END;
$$;