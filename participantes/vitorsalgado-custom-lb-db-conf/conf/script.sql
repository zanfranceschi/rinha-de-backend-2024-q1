-- general

SET TIME ZONE 'UTC';

-- tables

CREATE TABLE saldos (
    cliente_id INTEGER PRIMARY KEY NOT NULL,
    limite INT NOT NULL,
    saldo INT NOT NULL
);

CREATE TABLE transacoes (
    id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    tipo CHAR(1) NOT NULL,
    valor INT NOT NULL,
    realizado_em TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- indexes

CREATE INDEX idx_transacaos_cliente_id ON transacoes (cliente_id, id DESC);

-- functions

CREATE OR REPLACE FUNCTION fn_crebito(fn_cliente_id INT, fn_descricao VARCHAR(10), fn_tipo CHAR(1), fn_valor INT)
RETURNS TABLE (fn_res_saldo_final INT, fn_res_code INT)
AS $$
DECLARE v_saldo INT; v_limite INT;
BEGIN
    PERFORM pg_advisory_xact_lock(fn_cliente_id);
	
    IF fn_tipo = 'c' THEN 
        INSERT INTO transacoes (cliente_id, descricao, tipo, valor) 
            VALUES(fn_cliente_id, fn_descricao, 'c', fn_valor);

        RETURN QUERY
            UPDATE saldos
            SET saldo = saldo + fn_valor
            WHERE cliente_id = fn_cliente_id
            RETURNING saldo, 1;
    ELSE
        SELECT limite, saldo INTO v_limite, v_saldo FROM saldos WHERE cliente_id = fn_cliente_id;
        IF NOT FOUND THEN
            RETURN QUERY
                SELECT 0, 3;
        END IF;

        IF v_saldo - fn_valor >= v_limite * -1 THEN 
            INSERT INTO transacoes (cliente_id, descricao, tipo, valor) 
            VALUES(fn_cliente_id, fn_descricao, fn_tipo, fn_valor);
            
            RETURN QUERY
                UPDATE saldos
                SET saldo = saldo - fn_valor
                WHERE cliente_id = fn_cliente_id
                RETURNING saldo, 1;
        ELSE
            RETURN QUERY
                SELECT v_saldo, 2;
        END IF;
    END IF;
END;
$$
LANGUAGE plpgsql;

-- insert init data

INSERT INTO saldos (cliente_id, limite, saldo)
VALUES 
(1, 100000, 0),
(2, 80000, 0),
(3, 1000000, 0),
(4, 10000000, 0),
(5, 500000, 0);
