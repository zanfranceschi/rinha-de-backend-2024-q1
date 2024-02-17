SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;
SET default_tablespace = '';

CREATE UNLOGGED TABLE customers (
	id SERIAL PRIMARY KEY,
	saldo INTEGER NOT NULL,
	limite INTEGER NOT NULL
);

CREATE UNLOGGED TABLE transacoes (
	id SERIAL PRIMARY KEY,
	customerId INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_cliente_transacao_id
		FOREIGN KEY (customerId) REFERENCES customers(id)
);

CREATE INDEX ix_transacao_idcliente ON transacoes
(
    customerId ASC
);

DO $$
BEGIN
	INSERT INTO customers (limite, saldo)
	VALUES
		(100000, 0),
		(80000, 0),
		(1000000, 0),
		(10000000, 0),
		(500000, 0);
END;
$$;

CREATE OR REPLACE FUNCTION debit(
	customerId INT,
	valor INT,
	descricao VARCHAR(10))
RETURNS TABLE (saldoFinal INT, error BOOL)
LANGUAGE plpgsql
AS $$
DECLARE
	limiteAtual int;
	saldoAtual int;
BEGIN
	PERFORM pg_advisory_xact_lock(customerId);
	SELECT 
		c.limite,
		c.saldo 
	INTO
		limiteAtual,
		saldoAtual
	FROM customers c
	WHERE c.id = customerId;

	IF saldoAtual - valor < limiteAtual * -1 THEN
		RETURN QUERY 
			SELECT
				saldo,
				TRUE -- saldo insuficiente
			FROM customers
			WHERE id = customerId;
	ELSE
		INSERT INTO transacoes
			VALUES(DEFAULT, customerId, valor, 'd', descricao, DEFAULT);
		
		RETURN QUERY
			UPDATE customers
			SET saldo = saldo - valor
			WHERE id = customerId
			RETURNING saldo, FALSE;
	END IF;
END;
$$;

CREATE OR REPLACE FUNCTION credit(
	customerId INT,
	valor INT,
	descricao VARCHAR(10))
RETURNS TABLE (saldoFinal INT)
LANGUAGE plpgsql
AS $$
BEGIN
	PERFORM pg_advisory_xact_lock(customerId);

	INSERT INTO transacoes
		VALUES(DEFAULT, customerId, valor, 'c', descricao, DEFAULT);

	RETURN QUERY
		UPDATE customers
		SET saldo = saldo + valor
		WHERE id = customerId
		RETURNING saldo;
END;
$$;
