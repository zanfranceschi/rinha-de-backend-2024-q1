SET idle_in_transaction_session_timeout = 0;
SET check_function_bodies = false;
SET statement_timeout = 0;
SET lock_timeout = 0;

DROP TABLE IF EXISTS transacoes;
DROP TABLE IF EXISTS clientes;
DROP FUNCTION IF EXISTS CREATE_TRANSACATION;

CREATE UNLOGGED TABLE clientes (
    id INTEGER NOT NULL,
    limite INTEGER NOT NULL,
    saldo INTEGER CHECK((limite * -1) <= saldo) NOT NULL
);

CREATE UNLOGGED TABLE transacoes (
    cliente_id INTEGER NOT NULL,
    valor INTEGER NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    data TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_cliente_transacao ON transacoes(cliente_id);
CREATE INDEX idx_transacao_data ON transacoes(DATA DESC);

CREATE OR REPLACE FUNCTION CREATE_TRANSACATION(customer_id INTEGER, amount INTEGER, description VARCHAR(10)) RETURNS RECORD AS $$
DECLARE 
	ret RECORD;
BEGIN
				
	UPDATE clientes 
	SET 
		saldo = saldo + amount
	WHERE 
		id = (SELECT id FROM clientes WHERE id = customer_id FOR UPDATE)
	RETURNING saldo, limite, 0 INTO ret;
	
	IF ret IS NULL THEN
		RAISE EXCEPTION '-1';
	END IF;

	INSERT 
		INTO transacoes (cliente_id, valor, descricao)
	VALUES
		(customer_id, amount, description);

	RETURN ret;
EXCEPTION WHEN OTHERS THEN
	SELECT 0, 0, SQLERRM INTO ret;
	RETURN ret;
END;$$
LANGUAGE plpgsql;


INSERT INTO clientes VALUES(1, 100000, 0);
INSERT INTO clientes VALUES(2, 80000, 0);
INSERT INTO clientes VALUES(3, 1000000, 0);
INSERT INTO clientes VALUES(4, 10000000, 0);
INSERT INTO clientes VALUES(5, 500000, 0);