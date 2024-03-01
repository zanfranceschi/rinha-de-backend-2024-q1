CREATE UNLOGGED TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    limite INT NOT NULL
);

CREATE UNLOGGED TABLE saldos(
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE UNLOGGED TABLE transacoes (
    id SERIAL PRIMARY KEY,
    valor INT NOT NULL,
    tipo CHAR(1) CHECK (tipo IN ('c', 'd')) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    cliente_id INT,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

DO $$
BEGIN
	INSERT INTO clientes (nome, limite)
	VALUES
		('o barato sai caro', 1000 * 100),
		('zan corp ltda', 800 * 100),
		('les cruders', 10000 * 100),
		('padaria joia de cocaia', 100000 * 100),
		('kid mais', 5000 * 100);
	
	INSERT INTO saldos (cliente_id, valor)
		SELECT id, 0 FROM clientes;
END;
$$;