SET timezone TO 'America/Sao_Paulo';

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    "limit" INTEGER NOT NULL,
    balance INTEGER NOT NULL DEFAULT 0
);

INSERT INTO customers ("limit", balance)
VALUES
    (1000 * 100, 0),
    (800 * 100, 0),
    (10000 * 100, 0),
    (100000 * 100, 0),
    (5000 * 100, 0);

CREATE UNLOGGED TABLE transactions (
    id SERIAL PRIMARY KEY,
    customer_id SMALLINT NOT NULL,
    amount INTEGER NOT NULL,
    type CHAR(1) NOT NULL,
    description VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE
  transactions
SET
  (autovacuum_enabled = false);

CREATE INDEX idx_transactions ON transactions (customer_id asc);

CREATE OR REPLACE FUNCTION debit(
	customer_id_tx SMALLINT,
	amount_tx INT,
	description_tx VARCHAR(10))
RETURNS TABLE (
	new_balance INT,
	success BOOL,
	current_limit INT)
LANGUAGE plpgsql
AS $$
DECLARE
	current_balance int;
	current_limit_amount int;
BEGIN
	PERFORM pg_advisory_xact_lock(customer_id_tx);

	SELECT 
		"limit",
		balance
	INTO
		current_limit_amount,
		current_balance
	FROM customers
	WHERE id = customer_id_tx;

	IF current_balance - amount_tx >= current_limit_amount * -1 THEN
		INSERT INTO transactions VALUES(DEFAULT, customer_id_tx, amount_tx, 'd', description_tx);
		
		RETURN QUERY
    UPDATE customers 
    SET balance = balance - amount_tx 
    WHERE id = customer_id_tx
    RETURNING balance, TRUE, "limit";

	ELSE
		RETURN QUERY SELECT current_balance, FALSE, current_limit_amount;
	END IF;
END;
$$;

CREATE OR REPLACE FUNCTION credit(
	customer_id_tx SMALLINT,
	amount_tx INT,
	description_tx VARCHAR(10))
RETURNS TABLE (
	new_balance INT,
	success BOOL,
	current_limit INT)
LANGUAGE plpgsql
AS $$
BEGIN
	PERFORM pg_advisory_xact_lock(customer_id_tx);

	INSERT INTO transactions VALUES(DEFAULT, customer_id_tx, amount_tx, 'c', description_tx);

	RETURN QUERY
		UPDATE customers
		SET balance = balance + amount_tx
		WHERE id = customer_id_tx
		RETURNING balance, TRUE, "limit";
END;
$$;