CREATE TABLE clientes (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
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
        INSERT INTO clientes (nome, limite)
        VALUES ('Cleiton Rasta', 80000),
               ('Alonzo Church', 100000),
               ('Marcos Valle', 1000000),
               ('Vinicius de Moraes', 500000),
               ('Jose Raul Capablanca', 10000000);
	       
	INSERT INTO saldos (cliente_id, valor)
		SELECT id, 0 FROM clientes;
END;
$$;
