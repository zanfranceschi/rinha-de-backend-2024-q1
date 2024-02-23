CREATE UNLOGGED TABLE clientes (
	id SERIAL CONSTRAINT pk_clientes PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	limite INTEGER NOT NULL,
	saldo INTEGER NOT NULL
);

CREATE UNLOGGED TABLE transacoes (
	id SERIAL CONSTRAINT pk_transacoes PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC')
);

CREATE INDEX ix_transacoes_realizada_em ON transacoes (realizada_em DESC) INCLUDE (valor, tipo, descricao);
CREATE INDEX ix_clientes_extrato ON clientes (id) INCLUDE (limite, saldo);

DO $$
BEGIN
	INSERT INTO clientes (nome, limite, saldo)
	VALUES
		('o barato sai caro', 1000 * 100, 0),
		('zan corp ltda', 800 * 100, 0),
		('les cruders', 10000 * 100, 0),
		('padaria joia de cocaia', 100000 * 100, 0),
		('kid mais', 5000 * 100, 0);
END;
$$;

/*
Code table
---------------------------------
| Code  | Reason 				|
| 0		| Ok	 				|
| 1		| Insufficient funds	|
---------------------------------
*/

CREATE OR REPLACE FUNCTION debitar(
	cliente_id_tx INT,
	valor_tx INT,
	descricao_tx VARCHAR(10))
RETURNS TABLE (code INT, limite INT, saldo INT)
LANGUAGE plpgsql
AS $$
DECLARE
	saldo_atual INT;
	novo_saldo INT;
	limite_atual INT;
BEGIN
	SELECT 
		clientes.limite,
		clientes.saldo,
		clientes.saldo - valor_tx
	INTO
		limite_atual,
		saldo_atual,
		novo_saldo
	FROM clientes
	WHERE clientes.id = cliente_id_tx AND (clientes.saldo - valor_tx >= (clientes.limite * -1))
	FOR UPDATE;

	IF limite_atual IS NULL THEN
		RETURN QUERY
			SELECT 1, 0, 0;
	ELSE
		UPDATE clientes
		SET saldo = novo_saldo
		WHERE clientes.id = cliente_id_tx;
		
		INSERT INTO transacoes VALUES(DEFAULT, cliente_id_tx, valor_tx, 'd', descricao_tx, DEFAULT);

		RETURN QUERY
			SELECT 0, limite_atual, novo_saldo;
	END IF;
END;
$$;

CREATE OR REPLACE FUNCTION creditar(
	cliente_id_tx INT,
	valor_tx INT,
	descricao_tx VARCHAR(10))
RETURNS TABLE (code INT, limite INT, saldo INT)
LANGUAGE plpgsql
AS $$
DECLARE
	rec RECORD;
BEGIN
	UPDATE clientes
	SET saldo = clientes.saldo + valor_tx
	WHERE clientes.id = cliente_id_tx
	RETURNING clientes.limite, clientes.saldo
	INTO rec;

	INSERT INTO transacoes VALUES(DEFAULT, cliente_id_tx, valor_tx, 'c', descricao_tx, DEFAULT);

	RETURN QUERY 
		SELECT 0, rec.limite, rec.saldo;
END;
$$;
