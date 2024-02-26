--- TABLES
CREATE TABLE clients (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	client_limit INTEGER NOT NULL
);

CREATE TABLE transactions (
	id SERIAL PRIMARY KEY,
	client_id INTEGER NOT NULL,
	amount INTEGER NOT NULL,
	type CHAR(1) NOT NULL,
	description VARCHAR(10) NOT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_clients_transactions_id
		FOREIGN KEY (client_id) REFERENCES clients(id)
);

CREATE TABLE balances (
	id SERIAL PRIMARY KEY,
	client_id INTEGER NOT NULL,
	balance INTEGER NOT NULL,
	CONSTRAINT fk_clients_balances_id
		FOREIGN KEY (client_id) REFERENCES clients(id)
);

--- INDEX
CREATE INDEX idx_clients_id ON clients (id);
CREATE INDEX idx_transactions_client_id ON transactions (client_id);
CREATE INDEX idx_balances_client_id ON balances (client_id);
CREATE INDEX idx_transactions_client_id_created_at ON transactions (client_id, created_at DESC);

--- SEED
DO $$
BEGIN
	INSERT INTO clients (name, client_limit)
	VALUES
		('o barato sai caro', 1000 * 100),
		('zan corp ltda', 800 * 100),
		('les cruders', 10000 * 100),
		('padaria joia de cocaia', 100000 * 100),
		('kid mais', 5000 * 100);

	INSERT INTO balances (client_id, balance)
		SELECT id, 0 FROM clients;
END;
$$;
