CREATE TABLE customers (
	id SERIAL PRIMARY KEY,
	max_limit INTEGER NOT NULL,
	balance INTEGER NOT NULL
);

CREATE TABLE transactions (
	id SERIAL PRIMARY KEY,
	customer_id INTEGER NOT NULL,
	amount INTEGER NOT NULL,
	transaction_type CHAR(1) NOT NULL,
	description VARCHAR(10) NOT NULL,
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_customers_transactions_id
		FOREIGN KEY (customer_id) REFERENCES customers(id)
);

create index customer_created_idx ON transactions(customer_id,created_at DESC);

INSERT INTO customers (balance, max_limit)
VALUES
	(0, 1000 * 100),
	(0, 800 * 100),
	(0, 10000 * 100),
	(0, 100000 * 100),
	(0, 5000 * 100);