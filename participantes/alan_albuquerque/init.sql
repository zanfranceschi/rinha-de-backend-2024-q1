CREATE TABLE clientes
(
    id     SERIAL,
    saldo  INTEGER     NOT NULL,
    limite INTEGER     NOT NULL
);
CREATE INDEX ON clientes USING HASH(id);

CREATE UNLOGGED TABLE transacoes
(
    id           SERIAL,
    cliente_id   INTEGER     NOT NULL,
    valor        INTEGER     NOT NULL,
    tipo         CHAR(1)     NOT NULL,
    descricao    VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP   NOT NULL DEFAULT NOW()
);
CREATE INDEX ON transacoes (id DESC);
CREATE INDEX ON transacoes (cliente_id);
DO
$$
    BEGIN
        INSERT INTO clientes (limite, saldo)
        VALUES (1000 * 100, 0),
               (800 * 100, 0),
               (10000 * 100, 0),
               (100000 * 100, 0),
               (5000 * 100, 0);
    END;
$$;

CREATE OR REPLACE PROCEDURE CREATE_TRANSACTION_DEBIT(cid integer, value integer, type char, description text, OUT newBalance integer, OUT climit integer)
AS
$$
DECLARE
    balance int4;
BEGIN
    SELECT saldo, limite INTO balance, climit FROM clientes WHERE id = cid FOR UPDATE;
    newBalance = balance - value;
    IF -newBalance > climit THEN
        climit = -1;
        RETURN;
    END IF;
    UPDATE clientes SET saldo = newBalance WHERE id = cid;
    INSERT INTO transacoes (cliente_id, valor, tipo, descricao) VALUES (cid, value, type, description);
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE CREATE_TRANSACTION_CREDIT(cid integer, value integer, type char, description text, INOUT newBalance integer, INOUT climit integer)
AS
$$
DECLARE
    balance int4;
BEGIN
    SELECT saldo, limite INTO balance, climit FROM clientes WHERE id = cid FOR UPDATE;
    newBalance = balance + value;
    UPDATE clientes SET saldo = newBalance WHERE id = cid;
    INSERT INTO transacoes (cliente_id, valor, tipo, descricao) VALUES (cid, value, type, description);
END;
$$LANGUAGE plpgsql;