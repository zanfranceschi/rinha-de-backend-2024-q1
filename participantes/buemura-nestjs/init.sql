--- TABLES
CREATE TABLE customers (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	account_limit INTEGER NOT NULL
);

CREATE TABLE transactions (
	id SERIAL PRIMARY KEY,
	customer_id INTEGER NOT NULL,
	amount INTEGER NOT NULL,
	type CHAR(1) NOT NULL,
	description VARCHAR(10) NOT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_customers_transactions_id
		FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE balances (
	id SERIAL PRIMARY KEY,
	customer_id INTEGER NOT NULL,
	balance INTEGER NOT NULL,
	CONSTRAINT fk_customers_balances_id
		FOREIGN KEY (customer_id) REFERENCES customers(id)
);

--- INDEX
CREATE INDEX idx_customers_id ON customers (id);
CREATE INDEX idx_transactions_customer_id ON transactions (customer_id);
CREATE INDEX idx_balances_customer_id ON balances (customer_id);
CREATE INDEX idx_transactions_customer_id_created_at ON transactions (customer_id, created_at DESC);

--- SEED
DO $$
BEGIN
	INSERT INTO customers (name, account_limit)
	VALUES
		('o barato sai caro', 1000 * 100),
		('zan corp ltda', 800 * 100),
		('les cruders', 10000 * 100),
		('padaria joia de cocaia', 100000 * 100),
		('kid mais', 5000 * 100);
	
	INSERT INTO balances (customer_id, balance)
		SELECT id, 0 FROM customers;
END;
$$;