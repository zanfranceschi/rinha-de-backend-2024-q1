DROP SCHEMA IF EXISTS backend CASCADE;
DROP PROCEDURE IF EXISTS INSERIR_TRANSACAO_D CASCADE;
DROP PROCEDURE IF EXISTS INSERIR_TRANSACAO_C CASCADE;

CREATE SCHEMA backend;

CREATE UNLOGGED TABLE backend.clientes (
	id      SERIAL PRIMARY KEY,
	nome    VARCHAR(200) NOT NULL,
	limite  INTEGER NOT NULL,
    saldo   INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX idx_clientesaldo ON backend.clientes (id, saldo);

CREATE UNLOGGED TABLE backend.transacoes (
	id      SERIAL PRIMARY KEY,
    cliente_id SERIAL REFERENCES backend.clientes(id),
	valor  INTEGER NOT NULL,
	tipo   VARCHAR(1) NOT NULL,
	descricao   VARCHAR(10) NOT NULL,
	saldo_rmsc INTEGER NOT NULL,
	realizada_em   VARCHAR(200) NOT NULL
);

CREATE INDEX idx_extrato ON backend.transacoes (id desc, cliente_id);

INSERT INTO backend.clientes (nome, limite)
VALUES
  ('o barato sai caro', 1000 * 100),
  ('zan corp ltda', 800 * 100),
  ('les cruders', 10000 * 100),
  ('padaria joia de cocaia', 100000 * 100),
  ('kid mais', 5000 * 100);


CREATE PROCEDURE INSERIR_TRANSACAO_D(
	p_id_cliente INTEGER,
	p_valor INTEGER,
	p_descricao VARCHAR(10),
	p_realizada_em VARCHAR(200),
	INOUT pout_saldo INTEGER DEFAULT NULL,
	INOUT pout_limite INTEGER DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
  WITH
	UPDATE_CLIENTES AS (
		UPDATE backend.clientes
		SET saldo = saldo - p_valor
		WHERE id = p_id_cliente AND saldo - p_valor >= -limite
		RETURNING saldo, limite
	),
	INSERT_TRANSACAO AS (
		INSERT INTO backend.transacoes (cliente_id, valor, tipo, descricao, saldo_rmsc, realizada_em)
		SELECT p_id_cliente, p_valor, 'd', p_descricao, saldo, p_realizada_em
		from UPDATE_CLIENTES
	)
	SELECT saldo, limite
	INTO pout_saldo, pout_limite
	FROM UPDATE_CLIENTES;
END;
$$;

CREATE PROCEDURE INSERIR_TRANSACAO_C(
	p_id_cliente INTEGER,
	p_valor INTEGER,
	p_descricao VARCHAR(10),
	p_realizada_em VARCHAR(200),
	INOUT pout_saldo INTEGER DEFAULT NULL,
	INOUT pout_limite INTEGER DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
  WITH
	UPDATE_CLIENTES AS (
		UPDATE backend.clientes
		SET saldo = saldo + p_valor
		WHERE id = p_id_cliente
		RETURNING saldo, limite
	),
	INSERT_TRANSACAO AS (
		INSERT INTO backend.transacoes (cliente_id, valor, tipo, descricao, saldo_rmsc, realizada_em)
		SELECT p_id_cliente, p_valor, 'c', p_descricao, saldo, p_realizada_em
		from UPDATE_CLIENTES
	)
	
	SELECT saldo, limite
	INTO pout_saldo, pout_limite
	FROM UPDATE_CLIENTES;
END;
$$;
