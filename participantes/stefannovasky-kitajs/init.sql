CREATE UNLOGGED TABLE customers (
	id SERIAL PRIMARY KEY,
	"limit" INTEGER NOT NULL,
	balance INTEGER NOT NULL DEFAULT 0
);

CREATE UNLOGGED TABLE transactions (
	id SERIAL PRIMARY KEY,
	customer_id INTEGER NOT NULL,
	"value" INTEGER NOT NULL,
	"type" CHAR(1) NOT NULL,
	"description" VARCHAR(10) NOT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_transactions_customer_id
		FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE INDEX ix_transactions_customer_id_created_at ON transactions (customer_id, created_at DESC);

CREATE FUNCTION debit(customer_id INTEGER, trx_value INTEGER, trx_description TEXT)
RETURNS SETOF INTEGER
LANGUAGE plpgsql
AS $BODY$
	DECLARE customer_balance INTEGER;
	DECLARE customer_limit INTEGER;
BEGIN
	SELECT
		balance - trx_value,
		"limit"
	INTO customer_balance, customer_limit
	FROM customers
	WHERE id = customer_id
	FOR UPDATE;

	IF customer_balance < (-customer_limit) THEN RETURN; END IF;

	INSERT INTO transactions (customer_id, "value", "type", "description")
	VALUES (customer_id, trx_value, 'd', trx_description);

	RETURN QUERY
	UPDATE customers
	SET balance = customer_balance
	WHERE id = customer_id
	RETURNING balance;
END;
$BODY$;

CREATE FUNCTION credit(customer_id INTEGER, trx_value INTEGER, trx_description TEXT)
RETURNS SETOF INTEGER
LANGUAGE plpgsql
AS $BODY$
BEGIN
	INSERT INTO transactions (customer_id, "value", "type", "description")
	VALUES (customer_id, trx_value, 'c', trx_description);

	RETURN QUERY
	UPDATE customers
	SET balance = balance + trx_value
	WHERE id = customer_id
	RETURNING balance;
END;
$BODY$;

INSERT INTO customers (id, "limit") values
	(1, 1000 * 100),
	(2, 800 * 100),
	(3, 10000 * 100),
	(4, 100000 * 100),
	(5, 5000 * 100);
