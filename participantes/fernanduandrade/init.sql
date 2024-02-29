DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS transactions;

CREATE UNLOGGED TABLE clients (
	id SERIAL PRIMARY KEY,
	saldo INTEGER NOT null default 0,
	limite INTEGER NOT NULL
);

CREATE UNLOGGED TABLE transactions (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL DEFAULT NOW(),
	constraint fk_clients_transactions_id
		foreign key (cliente_id) references clients(id)
);

CREATE INDEX ids_transacoes_ids_cliente_id ON transactions (cliente_id);


DO $$
BEGIN
	INSERT INTO clients (saldo, limite)
	VALUES
		(0, 1000 * 100),
		(0, 800 * 100),
		(0, 10000 * 100),
		(0, 100000 * 100),
		(0, 5000 * 100);
END;
$$;

CREATE OR REPLACE FUNCTION debitar(
	cliente_id_tx INT,
	valor_tx INT8,
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
		limite,
		saldo
	INTO
		limite_atual,
		saldo_atual
	FROM clients
	WHERE id  = cliente_id_tx;

	IF saldo_atual - valor_tx >= limite_atual * -1 THEN
		INSERT INTO transactions
			VALUES(DEFAULT, cliente_id_tx, valor_tx, 'd', descricao_tx, NOW());
		
		UPDATE clients
		SET saldo = saldo - valor_tx
		WHERE id = cliente_id_tx;

		RETURN QUERY
			SELECT
				saldo,
				FALSE,
				'ok'::VARCHAR(20)
			FROM clients
			where id = cliente_id_tx;
	ELSE
		RETURN QUERY
			SELECT
				saldo,
				TRUE,
				'saldo insuficente'::VARCHAR(20)
			FROM clients
			WHERE id = cliente_id_tx;
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

	INSERT INTO transactions 
		VALUES(DEFAULT, cliente_id_tx, valor_tx, 'c', descricao_tx, NOW());

	RETURN QUERY
		UPDATE clients
		SET saldo  = saldo  + valor_tx
		WHERE id  = cliente_id_tx
		RETURNING saldo , FALSE, 'ok'::VARCHAR(20);
END;
$$;