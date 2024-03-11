CREATE UNLOGGED TABLE clientes (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	limite INTEGER NOT NULL,
	saldo INTEGER 
);

CREATE UNLOGGED TABLE transacoes (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL DEFAULT NOW()
);

ALTER TABLE
    transacoes
ADD
    CONSTRAINT fk_cliente_id FOREIGN KEY (cliente_id) REFERENCES clientes (id),
SET
    (autovacuum_enabled = off);

CREATE INDEX ON transacoes (cliente_id, realizada_em DESC);

INSERT INTO clientes (nome, limite, saldo)
VALUES
	('o barato sai caro', 1000 * 100, 0),
	('zan corp ltda', 800 * 100,  0),
	('les cruders', 10000 * 100, 0),
	('padaria joia de cocaia', 100000 * 100, 0),
	('kid mais', 5000 * 100, 0);

CREATE TYPE result_transacao AS (saldo_atual INT, limite INT);

CREATE OR REPLACE FUNCTION transacao(cliente_id_tx INTEGER, valor_tx INTEGER, tipo_tx VARCHAR(1), descricao_tx VARCHAR(10)) RETURNS result_transacao AS $$
DECLARE
	saldo INTEGER;
  limite INTEGER;
	saldo_atual INTEGER;
BEGIN
	PERFORM pg_advisory_xact_lock(cliente_id_tx);
	SELECT
		COALESCE(c.saldo, 0),
		c.limite
	INTO
		saldo,
		limite
	FROM clientes c
	WHERE c.id = cliente_id_tx;

	IF tipo_tx = 'd' THEN
		saldo_atual := saldo - valor_tx;
		IF saldo_atual + limite < 0 THEN
			RETURN (0, -1);
		END IF;
	ELSE
		saldo_atual := saldo + valor_tx;
	END IF;		
	
	UPDATE clientes c
	SET
		saldo = saldo_atual
	WHERE 
		c.id = cliente_id_tx;

	INSERT INTO 
		transacoes (cliente_id, valor, tipo, descricao)
	VALUES (cliente_id_tx, valor_tx, tipo_tx, descricao_tx);

	RETURN (saldo_atual, limite);
END;$$
LANGUAGE plpgsql;