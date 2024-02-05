CREATE TABLE clientes (
	id SERIAL PRIMARY KEY,
	limite INTEGER NOT NULL
);

CREATE TABLE transacoes (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_clientes_transacoes_id
		FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TABLE saldos (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	CONSTRAINT fk_clientes_saldos_id
		FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

DO $$
BEGIN
	INSERT INTO clientes (limite)
	VALUES
		(1000 * 100),
		(800 * 100),
		(10000 * 100),
		(100000 * 100),
		(5000 * 100);
	
	INSERT INTO saldos (cliente_id, valor)
		SELECT id, 0 FROM clientes;
END;
$$;