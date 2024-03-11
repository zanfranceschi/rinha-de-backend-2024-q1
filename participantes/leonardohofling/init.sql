CREATE UNLOGGED TABLE customers (
	customer_id SERIAL PRIMARY KEY,
	customer_name VARCHAR(50) NOT NULL,
	customer_limit INTEGER NOT NULL,
	customer_balance INTEGER NOT NULL
);

CREATE UNLOGGED TABLE transactions (
	transaction_id SERIAL PRIMARY KEY,
	customer_id INTEGER NOT NULL,
	transaction_amount INTEGER NOT NULL,
	transaction_type CHAR(1) NOT NULL,
	transaction_description VARCHAR(100) NOT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_customers_transactions_id
		FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

DO $$
BEGIN
	INSERT INTO customers (customer_name, customer_limit, customer_balance)
	VALUES
		('neo', 1000 * 100, 0),
		('trinity', 800 * 100, 0),
		('alice', 10000 * 100, 0),
		('goku', 100000 * 100, 0),
		('chupeta de baleia', 5000 * 100, 0);

END;
$$;