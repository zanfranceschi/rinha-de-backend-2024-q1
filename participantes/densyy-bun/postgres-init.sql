-- Tabelas

CREATE UNLOGGED TABLE clientes (
	id SERIAL PRIMARY KEY,
	limite INTEGER NOT NULL,
	saldo INTEGER NOT NULL
  CONSTRAINT saldo_limite CHECK (saldo >= limite * -1)
);

CREATE UNLOGGED TABLE transacoes (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	data_registro TIMESTAMP NOT NULL DEFAULT NOW(),
  CONSTRAINT fk_clientes_transacoes_id FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- Indices

CREATE INDEX idx_clientes_id ON clientes (id);
CREATE INDEX idx_transacoes_cliente_id ON transacoes (cliente_id);

-- Funcoes

CREATE OR REPLACE FUNCTION credito(_id INTEGER, valor INTEGER, descricao VARCHAR)
RETURNS json AS $$
DECLARE
  saldo_final INTEGER;
  limite_final INTEGER;
BEGIN

  PERFORM pg_advisory_xact_lock(_id);

  INSERT INTO transacoes (cliente_id, valor, tipo, descricao) VALUES (_id, valor, 'c', descricao);
  UPDATE clientes SET saldo = saldo + valor WHERE id = _id;

  SELECT saldo, limite INTO saldo_final, limite_final FROM clientes WHERE id = _id;
  RETURN json_build_object('saldo', saldo_final, 'limite', limite_final);

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION debito(_id INTEGER, valor INTEGER, descricao VARCHAR)
RETURNS json AS $$
DECLARE
  saldo_antigo INTEGER;
  limite_antigo INTEGER;
  saldo_final INTEGER;
  limite_final INTEGER;
BEGIN

  PERFORM pg_advisory_xact_lock(_id);

  SELECT saldo, limite INTO saldo_antigo, limite_antigo FROM clientes WHERE id = _id;
  IF (saldo_antigo - valor < limite_antigo * -1) THEN
    RETURN json_build_object('error', true);
  END IF;

  INSERT INTO transacoes (cliente_id, valor, tipo, descricao) VALUES (_id, valor, 'd', descricao);
  UPDATE clientes SET saldo = saldo - valor WHERE id = _id;

  SELECT saldo, limite INTO saldo_final, limite_final FROM clientes WHERE id = _id;
  RETURN json_build_object('saldo', saldo_final, 'limite', limite_final);

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION historico(_id INTEGER)
RETURNS json AS $$
DECLARE
  cliente_info json;
  transacoes_info json;
BEGIN

  PERFORM pg_advisory_xact_lock(_id);

  SELECT row_to_json(t) INTO cliente_info FROM (
    SELECT limite, saldo FROM clientes WHERE id = _id
  ) t;

  SELECT json_agg(row_to_json(t)) INTO transacoes_info FROM (
    SELECT valor, tipo, descricao, data_registro FROM transacoes WHERE cliente_id = _id ORDER BY data_registro DESC LIMIT 10
  ) t;

  RETURN json_build_object('cliente', cliente_info, 'transacoes', transacoes_info);

END;
$$ LANGUAGE plpgsql;

-- Dados iniciais

DO $$
BEGIN
	INSERT INTO clientes (id, limite, saldo)
	VALUES
    (1, 1000 * 100, 0),
    (2, 800 * 100, 0),
    (3, 10000 * 100, 0),
    (4, 100000 * 100, 0),
    (5, 5000 * 100, 0);
END;
$$;

-- Tune Postgres

ALTER SYSTEM SET max_connections = '200';
ALTER SYSTEM SET shared_buffers = '72960kB';
ALTER SYSTEM SET effective_cache_size = '218880kB';
ALTER SYSTEM SET maintenance_work_mem = '18240kB';
ALTER SYSTEM SET checkpoint_completion_target = '0.9';
ALTER SYSTEM SET wal_buffers = '2188kB';
ALTER SYSTEM SET default_statistics_target = '100';
ALTER SYSTEM SET random_page_cost = '1.1';
ALTER SYSTEM SET effective_io_concurrency = '200';
ALTER SYSTEM SET work_mem = '182kB';
ALTER SYSTEM SET huge_pages = 'off';
ALTER SYSTEM SET min_wal_size = '1GB';
ALTER SYSTEM SET max_wal_size = '4GB';
