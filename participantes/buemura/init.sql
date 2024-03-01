--- TABLES
CREATE UNLOGGED TABLE customers (
	id INT PRIMARY KEY,
	account_limit INTEGER NOT NULL,
	account_balance INTEGER NOT NULL DEFAULT 0
);

CREATE UNLOGGED TABLE transactions (
	id SERIAL PRIMARY KEY,
	customer_id INTEGER NOT NULL,
	amount INTEGER NOT NULL,
	type CHAR(1) NOT NULL,
	description VARCHAR(10) NOT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_customers_transactions_id
		FOREIGN KEY (customer_id) REFERENCES customers(id)
);

--- INDEX
CREATE INDEX idx_customers_id ON customers (id) INCLUDE (account_limit, account_balance);
CREATE INDEX idx_transactions_customer_id ON transactions (customer_id);
CREATE INDEX idx_transactions_customer_id_created_at ON transactions (customer_id, created_at DESC);

--- SEED
DO $$
BEGIN
	INSERT INTO customers (id, account_limit)
	VALUES (1, 1000 * 100), (2, 800 * 100), (3, 10000 * 100), (4, 100000 * 100), (5, 5000 * 100);
END;
$$;