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

CREATE OR REPLACE FUNCTION cliente_atualizar_saldo(valor INTEGER, cliente_id INTEGER)
RETURNS VOID AS $$
BEGIN
  UPDATE clientes SET saldo = saldo + valor WHERE id = cliente_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION cliente_receber_por_id(_id INTEGER)
RETURNS SETOF clientes AS $$
BEGIN
  RETURN QUERY SELECT * FROM clientes WHERE id = _id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION transacoes_adicionar(_id INTEGER, valor INTEGER, tipo CHAR, descricao VARCHAR)
RETURNS VOID AS $$
BEGIN
  INSERT INTO transacoes (cliente_id, valor, tipo, descricao) VALUES (_id, valor, tipo, descricao);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION transacoes_receber_historico(_id INTEGER)
RETURNS SETOF transacoes AS $$
BEGIN
  RETURN QUERY SELECT * FROM transacoes WHERE cliente_id = _id ORDER BY data_registro DESC LIMIT 10;
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
