DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS clients;

CREATE TABLE clients (
	id BIGSERIAL PRIMARY KEY,
	name VARCHAR(255),
	credit INTEGER,
	balance INTEGER DEFAULT 0
);

CREATE TABLE transactions (
	id BIGSERIAL PRIMARY KEY,
	value INTEGER,
	description VARCHAR(10),
	operation CHAR(1),
	client_id INT,
	created_at TIMESTAMP NOT NULL DEFAULT NOW(),
	FOREIGN KEY (client_id) REFERENCES Clients(id)
);

INSERT INTO clients (id, name, credit)
VALUES
	(1,'o barato sai caro', 1000 * 100),
	(2,'zan corp ltda', 800 * 100),
	(3,'les cruders', 10000 * 100),
	(4,'padaria joia de cocaia', 100000 * 100),
	(5,'kid mais', 5000 * 100);