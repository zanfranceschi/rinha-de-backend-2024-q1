CREATE UNLOGGED TABLE transacoes (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE UNLOGGED TABLE saldos (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	limite INTEGER NOT NULL,
	valor INTEGER NOT NULL
);

CREATE INDEX idx_transacoes_cliente_id ON transacoes (cliente_id);
CREATE INDEX idx_saldos_cliente_id ON saldos (cliente_id);

DO $$
BEGIN
	INSERT INTO saldos (cliente_id, limite, valor)
	VALUES (1,   100000, 0),
		   (2,    80000, 0),
		   (3,  1000000, 0),
		   (4, 10000000, 0),
		   (5,   500000, 0);
END;
$$;
