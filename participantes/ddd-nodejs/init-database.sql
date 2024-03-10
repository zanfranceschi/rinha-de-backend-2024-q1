CREATE UNLOGGED TABLE TRANSACAO (
    "id" SERIAL PRIMARY KEY,
    "realizada_em" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    "tipo" VARCHAR(1) NOT NULL,
    "descricao" VARCHAR(10) NOT NULL,
    "valor" INTEGER NOT NULL,
    "id_cliente" INTEGER NOT NULL
);

CREATE INDEX CONCURRENTLY IF NOT EXISTS "ID_CLIENT_INDEX" ON TRANSACAO ("id_cliente");
CREATE INDEX CONCURRENTLY IF NOT EXISTS "REALIZADA_EM_INDEX" ON TRANSACAO ("realizada_em" DESC);

CREATE UNLOGGED TABLE USUARIO (
    "id_cliente" INTEGER PRIMARY KEY,
    "limite" INTEGER NOT NULL,
    "saldo" INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX CONCURRENTLY IF NOT EXISTS "PK_ID_CLIENT_SALDO_INDEX" ON USUARIO ("id_cliente") INCLUDE ("saldo");

ALTER TABLE TRANSACAO ADD CONSTRAINT "FKEY_TRANSACAO_ID_CLIENT" FOREIGN KEY ("id_cliente") REFERENCES USUARIO("id_cliente");

DO $$
BEGIN
    INSERT INTO USUARIO ("id_cliente", "limite", "saldo") VALUES (1, 100000, 0);
    INSERT INTO USUARIO ("id_cliente", "limite", "saldo") VALUES (2, 80000, 0);
    INSERT INTO USUARIO ("id_cliente", "limite", "saldo") VALUES (3, 1000000, 0);
    INSERT INTO USUARIO ("id_cliente", "limite", "saldo") VALUES (4, 10000000, 0);
    INSERT INTO USUARIO ("id_cliente", "limite", "saldo") VALUES (5, 500000, 0);
END $$;

CREATE OR REPLACE FUNCTION ADD_CREDIT_TRANSACTION(
    FC_CLIENT_ID INTEGER, 
    FC_VALOR INTEGER, 
    FC_DESCRICAO VARCHAR(10), 
    OUT FC_SALDO_ATT INTEGER
)
AS $$
BEGIN
    INSERT INTO TRANSACAO (tipo, descricao, valor, id_cliente) 
    VALUES ('c', FC_DESCRICAO, FC_VALOR, FC_CLIENT_ID);

    PERFORM pg_advisory_xact_lock(FC_CLIENT_ID);

    UPDATE USUARIO 
    SET saldo = saldo + FC_VALOR 
    WHERE id_cliente = FC_CLIENT_ID
    RETURNING saldo INTO FC_SALDO_ATT;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ADD_DEBIT_TRANSACTION(
    FC_CLIENT_ID INTEGER, 
    FC_VALOR INTEGER, 
    FC_DESCRICAO VARCHAR(10),
    FC_LIMITE INTEGER,
    OUT FC_SALDO_ATT INTEGER
)
AS $$
BEGIN
    PERFORM pg_advisory_xact_lock(FC_CLIENT_ID);

    UPDATE USUARIO
    SET saldo = saldo - FC_VALOR 
    WHERE id_cliente = FC_CLIENT_ID AND FC_LIMITE + (saldo - FC_VALOR) >= 0
    RETURNING saldo INTO FC_SALDO_ATT;

    IF FC_SALDO_ATT IS NULL THEN
        RETURN;
    END IF;

    INSERT INTO TRANSACAO (tipo, descricao, valor, id_cliente) 
    VALUES ('d', FC_DESCRICAO, FC_VALOR, FC_CLIENT_ID);
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION LIST_BANK_STATEMENT(
    FC_CLIENT_ID INTEGER
)
RETURNS TABLE (
    id_cliente INTEGER,
    limite INTEGER,
    saldo INTEGER,
    realizada_em TIMESTAMP WITH TIME ZONE,
    tipo VARCHAR,
    descricao VARCHAR,
    valor INTEGER
) AS $$
BEGIN
    PERFORM pg_advisory_xact_lock(FC_CLIENT_ID);

    RETURN QUERY
    SELECT
        u."id_cliente",
        u."limite",
        u."saldo",
        t."realizada_em",
        t."tipo",
        t."descricao",
        t."valor"
    FROM USUARIO u
    LEFT JOIN TRANSACAO t ON t.id_cliente = u.id_cliente
    WHERE u.id_cliente = FC_CLIENT_ID
    ORDER BY t.realizada_em DESC
    LIMIT 10;
END $$ LANGUAGE plpgsql;
