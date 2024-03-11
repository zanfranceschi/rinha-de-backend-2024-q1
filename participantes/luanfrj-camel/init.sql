CREATE UNLOGGED TABLE transacoes (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE UNLOGGED TABLE clientes (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	limite INTEGER NOT NULL,
	saldo INTEGER NOT NULL
);

CREATE INDEX idx_cliente_id_trasacoes ON transacoes (cliente_id);
CREATE INDEX idx_cliente_id_clientes ON clientes (cliente_id);

DO $$
BEGIN
	INSERT INTO clientes (cliente_id, limite, saldo)
	VALUES (1,   1000 * 100, 0),
		   (2,    800 * 100, 0),
		   (3,  10000 * 100, 0),
		   (4, 100000 * 100, 0),
		   (5,   5000 * 100, 0);
END;
$$;