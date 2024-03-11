DROP TABLE IF EXISTS saldos;
DROP TABLE IF EXISTS transacoes;
DROP TABLE IF EXISTS clientes;

CREATE UNLOGGED TABLE IF NOT EXISTS clientes (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	limite INTEGER NOT NULL
);

CREATE UNLOGGED TABLE IF NOT EXISTS transacoes (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_clientes_transacoes_id
		FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE UNLOGGED TABLE IF NOT EXISTS saldos (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	CONSTRAINT fk_clientes_saldos_id
		FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE INDEX idx_transacoes_cliente_id ON transacoes (cliente_id);
CREATE INDEX idx_transacoes_criado_em ON transacoes (realizada_em);

DO $$
BEGIN
	INSERT INTO clientes (nome, limite)
	VALUES
		('o barato sai caro', 1000 * 100),
		('zan corp ltda', 800 * 100),
		('les cruders', 10000 * 100),
		('padaria joia de cocaia', 100000 * 100),
		('kid mais', 5000 * 100);

	INSERT INTO saldos (cliente_id, valor)
		SELECT id, 0 FROM clientes;
END;
$$;

CREATE OR REPLACE FUNCTION creditar(
	cliente_id_tx INT,
	valor_tx INT,
	saldo_tx INT,
	tipo_tx VARCHAR(2),
	descricao_tx VARCHAR(10))
RETURNS TABLE (
	novo_saldo INT,
	possui_erro BOOL,
	mensagem VARCHAR(20))
LANGUAGE plpgsql
AS $$
BEGIN
	--PERFORM pg_advisory_xact_lock(cliente_id_tx);

	INSERT INTO transacoes
		VALUES(DEFAULT, cliente_id_tx, valor_tx, tipo_tx, descricao_tx, NOW());

	RETURN QUERY
		UPDATE saldos
		SET valor = saldo_tx
		WHERE cliente_id = cliente_id_tx
		RETURNING valor, FALSE, 'ok'::VARCHAR(20);
END;
$$;