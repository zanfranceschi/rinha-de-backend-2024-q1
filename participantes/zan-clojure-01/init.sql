
CREATE UNLOGGED TABLE transacoes (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE UNLOGGED TABLE saldos (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	limite INTEGER NOT NULL,
	valor INTEGER NOT NULL
);

CREATE INDEX ids_transacoes_ids_cliente_id ON transacoes (cliente_id);
CREATE INDEX ids_saldos_ids_cliente_id ON saldos (cliente_id);

DO $$
BEGIN
	INSERT INTO saldos (cliente_id, limite, valor)
	VALUES (1,   1000 * 100, 0),
		   (2,    800 * 100, 0),
		   (3,  10000 * 100, 0),
		   (4, 100000 * 100, 0),
		   (5,   5000 * 100, 0);
END;
$$;

CREATE OR REPLACE FUNCTION debitar(
	cliente_id_tx INT,
	valor_tx INT,
	descricao_tx VARCHAR(10))
RETURNS TABLE (
	novo_saldo INT,
	possui_erro BOOL,
	mensagem VARCHAR(20))
LANGUAGE plpgsql
AS $$
DECLARE
	saldo_atual int;
	limite_atual int;
BEGIN
	PERFORM pg_advisory_xact_lock(cliente_id_tx);
	SELECT 
		s.limite,
		COALESCE(s.valor, 0)
	INTO
		limite_atual,
		saldo_atual
	FROM saldos s
	WHERE s.cliente_id = cliente_id_tx;

	IF saldo_atual - valor_tx >= limite_atual * -1 THEN
		INSERT INTO transacoes
			VALUES(DEFAULT, cliente_id_tx, valor_tx, 'd', descricao_tx, NOW());
		
		UPDATE saldos
		SET valor = valor - valor_tx
		WHERE cliente_id = cliente_id_tx;

		RETURN QUERY
			SELECT
				valor,
				FALSE,
				'ok'::VARCHAR(20)
			FROM saldos
			WHERE cliente_id = cliente_id_tx;
	ELSE
		RETURN QUERY
			SELECT
				valor,
				TRUE,
				'saldo insuficente'::VARCHAR(20)
			FROM saldos
			WHERE cliente_id = cliente_id_tx;
	END IF;
END;
$$;

CREATE OR REPLACE FUNCTION creditar(
	cliente_id_tx INT,
	valor_tx INT,
	descricao_tx VARCHAR(10))
RETURNS TABLE (
	novo_saldo INT,
	possui_erro BOOL,
	mensagem VARCHAR(20))
LANGUAGE plpgsql
AS $$
BEGIN
	PERFORM pg_advisory_xact_lock(cliente_id_tx);

	INSERT INTO transacoes
		VALUES(DEFAULT, cliente_id_tx, valor_tx, 'c', descricao_tx, NOW());

	RETURN QUERY
		UPDATE saldos
		SET valor = valor + valor_tx
		WHERE cliente_id = cliente_id_tx
		RETURNING valor, FALSE, 'ok'::VARCHAR(20);
END;
$$;
