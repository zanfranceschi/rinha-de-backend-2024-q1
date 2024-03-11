DROP TABLE IF EXISTS transacoes;
DROP TABLE IF EXISTS clientes;

CREATE UNLOGGED TABLE clientes (
	cliente_id INTEGER PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	limite INTEGER NOT NULL,
	saldo INTEGER NOT NULL,
	saldo_atualizado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE UNLOGGED TABLE transacoes (
	transacao_id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	saldo INTEGER NOT NULL,
	CONSTRAINT fk__clientes__transacoes_id
		FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

CREATE INDEX ix__transacoes__cliente_cliente ON transacoes (cliente_id, realizada_em DESC);

DO $$
BEGIN
	INSERT INTO clientes (cliente_id, nome, limite, saldo)
	VALUES
		(1, 'o barato sai caro', 1000 * 100, 0),
		(2, 'zan corp ltda', 800 * 100, 0),
		(3, 'les cruders', 10000 * 100, 0),
		(4, 'padaria joia de cocaia', 100000 * 100, 0),
		(5, 'kid mais', 5000 * 100, 0);
END;
$$;
