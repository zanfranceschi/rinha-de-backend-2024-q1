CREATE UNLOGGED TABLE clientes (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(50) NOT NULL, -- nem precisa mas ta aí
	limite INTEGER NOT NULL,
	saldo INTEGER NOT NULL DEFAULT 0
);

CREATE UNLOGGED TABLE transacoes (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_clientes_transacoes_id
		FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE INDEX ix_transacoes_cliente_id_realizada_em ON transacoes (cliente_id, realizada_em DESC);

CREATE FUNCTION debito(cliente_id INTEGER, valor_transacao INTEGER, descricao_transacao TEXT)
RETURNS SETOF INTEGER -- retorna saldo do cliente apos a transacao
LANGUAGE plpgsql
AS $BODY$
	DECLARE cliente_novo_saldo INTEGER;
	DECLARE cliente_limite INTEGER;
BEGIN
	SELECT
		saldo - valor_transacao,
		limite
	INTO cliente_novo_saldo, cliente_limite
	FROM clientes
	WHERE id = cliente_id
	FOR UPDATE;

	IF cliente_novo_saldo < (-cliente_limite) THEN RETURN; END IF;

	INSERT INTO transacoes (cliente_id, valor, tipo, descricao)
	VALUES (cliente_id, valor_transacao, 'd', descricao_transacao);

	RETURN QUERY
	UPDATE clientes
	SET saldo = cliente_novo_saldo
	WHERE id = cliente_id
	RETURNING saldo;
END;
$BODY$;

CREATE FUNCTION credito(cliente_id INTEGER, valor_transacao INTEGER, descricao_transacao TEXT)
RETURNS SETOF INTEGER -- retorna saldo do cliente apos a transacao
LANGUAGE plpgsql
AS $BODY$
	DECLARE cliente_novo_saldo INTEGER;
BEGIN
	INSERT INTO transacoes (cliente_id, valor, tipo, descricao)
	VALUES (cliente_id, valor_transacao, 'c', descricao_transacao);

	RETURN QUERY
	UPDATE clientes
	SET saldo = saldo + valor_transacao
	WHERE id = cliente_id
	RETURNING saldo;
END;
$BODY$;

INSERT INTO clientes (nome, limite) values
	('eh', 1000 * 100),
	('os', 800 * 100),
	('guri', 10000 * 100),
	('nao tem', 100000 * 100),
	('jeito', 5000 * 100);
