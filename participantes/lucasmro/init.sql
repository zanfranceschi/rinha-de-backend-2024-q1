CREATE UNLOGGED TABLE IF NOT EXISTS account (
	id SERIAL PRIMARY KEY NOT NULL,
	name VARCHAR(50) NOT NULL,
	credit_limit INTEGER NOT NULL,
	balance integer NOT NULL
);

CREATE UNLOGGED TABLE IF NOT EXISTS account_transaction (
	id SERIAL PRIMARY KEY,
	account_id INTEGER NOT NULL,
	amount INTEGER NOT NULL,
	type CHAR(1) NOT NULL,
	description VARCHAR(10) NOT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_account_transaction_account_id ON account_transaction (account_id);

INSERT INTO account (id, name, credit_limit, balance)
VALUES
    (1, 'o barato sai caro', 1000 * 100, 0),
    (2, 'zan corp ltda', 800 * 100, 0),
    (3, 'les cruders', 10000 * 100, 0),
    (4, 'padaria joia de cocaia', 100000 * 100, 0),
    (5, 'kid mais', 5000 * 100, 0);

CREATE OR REPLACE FUNCTION process_transaction(
	account_id_tx INT,
	amount_tx INT,
	description_tx VARCHAR(10))
RETURNS TABLE (
	account_balance INT,
	account_credit_limit INT,
	error_code INT)
LANGUAGE plpgsql
AS $$
DECLARE
	current_balance INT;
	current_credit_limit INT;
	type_tx CHAR;
BEGIN
	PERFORM pg_advisory_xact_lock(account_id_tx);

	SELECT credit_limit, balance, (CASE WHEN amount_tx > 0 THEN 'c' ELSE 'd' END)
	INTO current_credit_limit, current_balance, type_tx
	FROM account
	WHERE id = account_id_tx;

	-- Account not found
	IF NOT FOUND THEN
		RETURN QUERY
			SELECT
				NULL::INTEGER,
				NULL::INTEGER,
				-1;
		RETURN;
	END IF;

	-- Insufficient balance
	IF (amount_tx < 0 AND current_credit_limit + current_balance + amount_tx < 0) THEN
		RETURN QUERY
			SELECT
				current_balance,
				current_credit_limit,
				-2;
		RETURN;
	END IF;

	-- Success
	INSERT INTO account_transaction (id, account_id, amount, type, description, created_at)
	VALUES(DEFAULT, account_id_tx, ABS(amount_tx), type_tx, description_tx, NOW());

	UPDATE account
	SET balance = current_balance + amount_tx
	WHERE id = account_id_tx;

	RETURN QUERY
		SELECT
			current_balance + amount_tx,
			current_credit_limit,
			NULL::INTEGER;
END;
$$;
