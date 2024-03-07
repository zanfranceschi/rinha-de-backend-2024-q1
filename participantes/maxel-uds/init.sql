DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
	id INTEGER PRIMARY KEY,
	saldo INTEGER,
	limite INTEGER
);

CREATE TABLE transactions (
	id SERIAL PRIMARY KEY,
	user_id INTEGER,
	valor INTEGER,
	tipo VARCHAR(1),
	descricao VARCHAR(10),
	criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO users (id, limite, saldo)
VALUES
(1, 100000, 0),
(2, 80000, 0),
(3, 1000000, 0),
(4, 10000000, 0),
(5, 500000, 0);