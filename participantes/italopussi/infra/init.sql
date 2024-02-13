CREATE UNLOGGED TABLE clients (
	id SERIAL PRIMARY KEY,
	credit_line INTEGER NOT NULL,
	balance INTEGER NOT NULL
);

CREATE UNLOGGED TABLE transactions (
	id SERIAL PRIMARY KEY,
	client_id INTEGER NOT NULL,
	amount INTEGER NOT NULL,
	operation CHAR(1) NOT NULL,
	summary VARCHAR(10) NOT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_clients_transactions_id
		FOREIGN KEY (client_id) REFERENCES clients(id)
);

INSERT INTO clients (credit_line, balance)
VALUES
	(1000 * 100, 0),
	(800 * 100, 0),
	(10000 * 100, 0),
	(100000 * 100, 0),
	(5000 * 100, 0);