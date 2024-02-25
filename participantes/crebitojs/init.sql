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
	valor INTEGER NOT NULL
);

CREATE INDEX transacoes_idx ON transacoes(cliente_id) INCLUDE (valor, tipo, descricao, realizada_em);

DO $$
BEGIN
	INSERT INTO saldos (cliente_id, valor)
	VALUES
		(1,0),
		(2,0),
		(3,0),
		(4,0),
		(5,0);

END;
$$;
