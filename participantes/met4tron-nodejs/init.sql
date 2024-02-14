-- Based on https://github.com/eupassarin/rinha2/blob/master/init.sql by https://github.com/eupassarin/rinha2

ALTER DATABASE rinha_db;

CREATE UNLOGGED TABLE IF NOT EXISTS clientes (id SMALLINT NOT NULL, limite INTEGER NOT NULL, saldo INTEGER NOT NULL DEFAULT 0);
CREATE INDEX IF NOT EXISTS pk_client_idx ON clientes (id) INCLUDE (saldo);

CREATE UNLOGGED TABLE IF NOT EXISTS transacoes (valor INTEGER NOT NULL,  tipo CHAR(1) NOT NULL, descricao VARCHAR(10) NOT NULL, realizada_em timestamp without time zone DEFAULT now(), id_cliente SMALLINT NOT NULL);

CREATE INDEX IF NOT EXISTS CLIENT_IDX ON transacoes (id_cliente);
CREATE INDEX IF NOT EXISTS REALIZADA_EM_IDX ON transacoes (realizada_em DESC);

CREATE FUNCTION ADD_DEBIT(ID_CLIENTE SMALLINT, VALOR INT, DESCRICAO TEXT, P_LIMITE INT, OUT NOVO_SALDO INT) LANGUAGE plpgsql AS $$
BEGIN
    PERFORM pg_advisory_xact_lock(ID_CLIENTE);

    UPDATE clientes SET saldo = saldo - VALOR
    WHERE id = ID_CLIENTE AND saldo - VALOR >= - P_LIMITE
    RETURNING saldo INTO NOVO_SALDO;

    IF NOVO_SALDO IS NULL THEN
        RETURN;
    END IF;

    INSERT INTO transacoes (id_cliente, valor, tipo, descricao)
    VALUES(ID_CLIENTE, valor, 'd', DESCRICAO);
END;
$$;

CREATE FUNCTION ADD_CREDIT(ID_CLIENTE SMALLINT, VALOR INT, DESCRICAO TEXT, OUT NOVO_SALDO INT) LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO transacoes (id_cliente, valor, tipo, descricao)
    VALUES(ID_CLIENTE, VALOR, 'c', DESCRICAO);

    PERFORM pg_advisory_xact_lock(ID_CLIENTE);
    UPDATE clientes SET saldo = saldo + valor
    WHERE id = ID_CLIENTE
    RETURNING saldo INTO NOVO_SALDO;
END;
$$;

DO $$
BEGIN
    INSERT INTO clientes
    VALUES  (1, 1000 * 100, 0),
            (2, 800 * 100, 0),
            (3, 10000 * 100, 0),
            (4, 100000 * 100, 0),
            (5, 5000 * 100, 0);
END;
$$;
