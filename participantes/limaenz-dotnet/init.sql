SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

CREATE UNLOGGED TABLE cliente (
    id SERIAL PRIMARY KEY,
    limite INTEGER NOT NULL,
    saldo INTEGER NOT NULL DEFAULT 0
);

CREATE UNLOGGED TABLE transacao (
    id SERIAL PRIMARY KEY,
    idCliente INTEGER NOT NULL,
    valor INTEGER NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizadoEm TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_transacao_idCliente ON transacao (idCliente ASC);

INSERT INTO cliente (id, limite, saldo)
VALUES 
    (1, 1000 * 100, 0),
    (2, 800 * 100, 0),
    (3, 10000 * 100, 0),
    (4, 100000 * 100, 0),
    (5, 5000 * 100, 0);

CREATE OR REPLACE FUNCTION realizar_credito(id_cliente INT, novo_valor INT, descricao_cd VARCHAR(10))
RETURNS TABLE (saldoAtual INT, erro BOOL)
LANGUAGE plpgsql 
AS $$
BEGIN
    PERFORM pg_advisory_xact_lock(id_cliente);
    INSERT INTO transacao (valor, tipo, descricao, realizadoEm, idCliente)
    VALUES (novo_valor, 'c', descricao_cd, NOW(), id_cliente);

    RETURN QUERY
    UPDATE cliente
    SET saldo = saldo + novo_valor
    WHERE id = id_cliente
	RETURNING saldo, FALSE;
END;
$$;

CREATE OR REPLACE FUNCTION realizar_debito(id_cliente INT, novo_valor INT, descricao_db VARCHAR(10))
RETURNS TABLE (saldoAtual INT, erro BOOL)
LANGUAGE plpgsql
AS $$
BEGIN
    PERFORM pg_advisory_xact_lock(id_cliente);
    IF (SELECT (saldo - novo_valor) >= (limite * -1) from cliente where id = id_cliente) THEN 
        INSERT INTO transacao (valor, tipo, descricao, realizadoEm, idCliente)
        VALUES (novo_valor, 'd', descricao_db, NOW(), id_cliente);

        UPDATE cliente
        SET saldo = saldo - novo_valor
        WHERE id = id_cliente;

        RETURN QUERY SELECT saldo, FALSE FROM cliente WHERE id = id_cliente;
    ELSE
        RETURN QUERY SELECT saldo, TRUE FROM cliente WHERE id = id_cliente;
    END IF;
END;
$$;


