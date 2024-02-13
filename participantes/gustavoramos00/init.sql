CREATE UNLOGGED TABLE cliente (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	limite INTEGER NOT NULL
);

CREATE UNLOGGED TABLE transacao (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_cliente_transacoes_id
		FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

CREATE UNLOGGED TABLE conta (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	saldo INTEGER NOT NULL,
	limite INTEGER NOT NULL,
	CONSTRAINT fk_cliente_conta_id
		FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

DO $$
BEGIN
	INSERT INTO cliente (nome, limite)
	VALUES
		('o barato sai caro', 1000 * 100),
		('zan corp ltda', 800 * 100),
		('les cruders', 10000 * 100),
		('padaria joia de cocaia', 100000 * 100),
		('kid mais', 5000 * 100);
	
	INSERT INTO conta (cliente_id, saldo, limite)
		SELECT id, 0, limite FROM cliente;
END;
$$;
