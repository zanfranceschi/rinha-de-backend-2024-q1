CREATE UNLOGGED TABLE IF NOT EXISTS cliente (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	limite INTEGER NOT NULL,
	saldo INTEGER NOT NULL DEFAULT 0
);

CREATE UNLOGGED TABLE IF NOT EXISTS transacao (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL,
	CONSTRAINT fk_cliente_transacao_id
		FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

CREATE INDEX idx_cliente_id ON transacao(cliente_id);

DO $$
BEGIN
	INSERT INTO cliente (nome, limite)
	VALUES
		('o barato sai caro', 1000 * 100),
		('zan corp ltda', 800 * 100),
		('les cruders', 10000 * 100),
		('padaria joia de cocaia', 100000 * 100),
		('kid mais', 5000 * 100);
END;
$$;
