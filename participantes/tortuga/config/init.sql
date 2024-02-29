CREATE TABLE accounts (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	limit_amount INTEGER NOT NULL
);

CREATE TABLE transactions (
	id SERIAL PRIMARY KEY,
	account_id INTEGER NOT NULL,
	amount INTEGER NOT NULL,
	transaction_type CHAR(1) NOT NULL,
	description VARCHAR(10) NOT NULL,
	date TIMESTAMP NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_accounts_transactions_id
		FOREIGN KEY (account_id) REFERENCES accounts(id)
);

CREATE TABLE balances (
	id SERIAL PRIMARY KEY,
	account_id INTEGER NOT NULL,
	amount INTEGER NOT NULL,
	CONSTRAINT fk_accounts_balances_id
		FOREIGN KEY (account_id) REFERENCES accounts(id)
);

DO $$
BEGIN
	INSERT INTO accounts (name, limit_amount)
	VALUES
		('o barato sai caro', 1000 * 100),
		('zan corp ltda', 800 * 100),
		('les cruders', 10000 * 100),
		('padaria joia de cocaia', 100000 * 100),
		('kid mais', 5000 * 100);
	
	INSERT INTO balances (account_id, amount)
		SELECT id, 0 FROM accounts;
END;
$$;
