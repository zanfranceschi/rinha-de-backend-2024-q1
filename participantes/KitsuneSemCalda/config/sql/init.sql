CREATE TABLE IF NOT EXISTS clientes (
	id SERIAL PRIMARY KEY,
	limite INT,
	saldo INT,
	created_at TIMESTAMP
);


CREATE TABLE IF NOT EXISTS transacoes (
	id SERIAL PRIMARY KEY,
	cliente_id INT NOT NULL,
	valor INT NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL,
  	created_at TIMESTAMP,
  	updated_at TIMESTAMP,
	FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

INSERT INTO clientes (id, limite, saldo) VALUES
(1, 100000, 0),
(2, 80000, 0),
(3, 1000000, 0),
(4, 10000000, 0),
(5, 500000, 0);
