DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS transacoes;

CREATE UNLOGGED TABLE clientes (
	id SERIAL PRIMARY KEY,
    saldo INTEGER NOT NULL,
    limite INTEGER NOT NULL
);

CREATE UNLOGGED TABLE transacoes (
	id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    valor INTEGER NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10),
    realizada_em TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX ix_transacoes_cliente_id ON transacoes (cliente_id);

INSERT INTO clientes (id, limite, saldo) VALUES
(1, 1000 * 100, 0),
(2, 800 * 100, 0),
(3, 10000 * 100, 0),
(4, 100000 * 100, 0),
(5, 5000 * 100, 0);

---------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION creditar(
	cliente_id_tx INT,
	valor_tx INT,
	descricao_tx VARCHAR(10))
RETURNS TABLE (
	novo_saldo INT,
	deu_erro BOOL,
	mensagem VARCHAR(20))
LANGUAGE plpgsql AS
$$
BEGIN
	PERFORM pg_advisory_xact_lock(cliente_id_tx);

	INSERT INTO transacoes VALUES
    (DEFAULT, cliente_id_tx, valor_tx, 'c', descricao_tx, NOW());

	RETURN QUERY
		UPDATE clientes
		SET saldo = saldo + valor_tx
		WHERE id = cliente_id_tx
		RETURNING saldo, FALSE, 'ok'::VARCHAR(20);
END;
$$;

---------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION debitar(
	cliente_id_tx INT,
	valor_tx INT,
	descricao_tx VARCHAR(10))
RETURNS TABLE (
	novo_saldo INT,
	deu_erro BOOL,
	mensagem VARCHAR(20))
LANGUAGE plpgsql AS
$$
DECLARE
	saldo_atual int;
	limite_atual int;
BEGIN
	PERFORM pg_advisory_xact_lock(cliente_id_tx);

	SELECT limite, COALESCE(saldo, 0)
	INTO limite_atual, saldo_atual
	FROM clientes
	WHERE id = cliente_id_tx;

	IF saldo_atual - valor_tx >= limite_atual * -1 THEN
		INSERT INTO transacoes VALUES
        (DEFAULT, cliente_id_tx, valor_tx, 'd', descricao_tx, NOW());

		UPDATE clientes
		SET saldo = saldo - valor_tx
		WHERE id = cliente_id_tx;

		RETURN QUERY
			SELECT saldo, FALSE, 'ok'::VARCHAR(20)
			FROM clientes
			WHERE id = cliente_id_tx;
	ELSE
		RETURN QUERY
			SELECT saldo, TRUE, 'not enough cash'::VARCHAR(20)
			FROM clientes
			WHERE id = cliente_id_tx;
	END IF;
END;
$$;
