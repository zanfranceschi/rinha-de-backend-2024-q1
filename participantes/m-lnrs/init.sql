CREATE UNLOGGED TABLE client (
	number SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	limit_amount INTEGER NOT NULL
);

CREATE UNLOGGED TABLE transaction (
	number SERIAL PRIMARY KEY,
	client_number INTEGER NOT NULL,
	amount INTEGER NOT NULL,
	type CHAR(1) NOT NULL,
	description VARCHAR(10) NOT NULL,
	done TIMESTAMP NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_transaction_client_number
		FOREIGN KEY (client_number) REFERENCES client(number)
);

CREATE UNLOGGED TABLE balance (
	number SERIAL PRIMARY KEY,
	client_number INTEGER NOT NULL,
	amount INTEGER NOT NULL,
	CONSTRAINT fk_balance_client_number
		FOREIGN KEY (client_number) REFERENCES client(number)
);

DO $$
BEGIN
	INSERT INTO client (name, limit_amount)
	VALUES
		('o barato sai caro', 1000 * 100),
		('zan corp ltda', 800 * 100),
		('les cruders', 10000 * 100),
		('padaria joia de cocaia', 100000 * 100),
		('kid mais', 5000 * 100);
	
	INSERT INTO balance (client_number, amount)
		SELECT number, 0 FROM client;

	CREATE INDEX idx_transaction_client_number ON transaction (done DESC);
END;
$$;

CREATE OR REPLACE FUNCTION debit(
	client_number_tx INT,
	amount_tx INT,
	description_tx VARCHAR(10))
RETURNS TABLE (
	new_balance INT,
	success BOOL,
	message VARCHAR(20))
LANGUAGE plpgsql
AS $$
DECLARE
	current_balance int;
	current_limit_amount int;
BEGIN
	PERFORM pg_advisory_xact_lock(client_number_tx);

	SELECT 
		client.limit_amount,
		COALESCE(balance.amount, 0)
	INTO
		current_limit_amount,
		current_balance
	FROM client
		LEFT JOIN balance
			ON client.number = balance.client_number
	WHERE client.number = client_number_tx;

	IF current_balance - amount_tx >= current_limit_amount * -1 THEN
		INSERT INTO transaction
			VALUES(DEFAULT, client_number_tx, amount_tx, 'd', description_tx, NOW());
		
		UPDATE balance
		SET amount = amount - amount_tx
		WHERE client_number = client_number_tx;

		RETURN QUERY
			SELECT
				amount,
				TRUE,
				'OK'::VARCHAR(20)
			FROM balance
			WHERE client_number = client_number_tx;
	ELSE
		RETURN QUERY
			SELECT
				amount,
				FALSE,
				'NSF'::VARCHAR(20)
			FROM balance
			WHERE client_number = client_number_tx;
	END IF;
END;
$$;

CREATE OR REPLACE FUNCTION credit(
	client_number_tx INT,
	amount_tx INT,
	description_tx VARCHAR(10))
RETURNS TABLE (
	new_balance INT,
	success BOOL,
	message VARCHAR(20))
LANGUAGE plpgsql
AS $$
BEGIN
	PERFORM pg_advisory_xact_lock(client_number_tx);

	INSERT INTO transaction
		VALUES(DEFAULT, client_number_tx, amount_tx, 'c', description_tx, NOW());

	RETURN QUERY
		UPDATE balance
		SET amount = amount + amount_tx
		WHERE client_number = client_number_tx
		RETURNING amount, TRUE, 'OK'::VARCHAR(20);
END;
$$;
