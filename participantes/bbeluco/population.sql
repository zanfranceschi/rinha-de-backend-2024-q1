DROP DATABASE IF EXISTS "rinhadb";
CREATE DATABASE "rinhadb";

\c rinhadb;

CREATE UNLOGGED TABLE clients (
    id INT UNIQUE NOT NULL,
    limite INT, 
    balance INT,
    PRIMARY KEY(id)
);


CREATE UNLOGGED TABLE transactions1 (
    id SERIAL,
    valor INT NOT NULL,
    tipo VARCHAR(10),
    descricao VARCHAR(10) NOT NULL,
    realizada_em timestamptz NULL
);

CREATE UNLOGGED TABLE transactions2 (
    id SERIAL,
    client_id INT,
    valor INT NOT NULL,
    tipo VARCHAR(10),
    descricao VARCHAR(10) NOT NULL,
    realizada_em timestamptz NULL
);

CREATE UNLOGGED TABLE transactions3 (
    id SERIAL,
    client_id INT,
    valor INT NOT NULL,
    tipo VARCHAR(10),
    descricao VARCHAR(10) NOT NULL,
    realizada_em timestamptz NULL
);

CREATE UNLOGGED TABLE transactions4 (
    id SERIAL,
    client_id INT,
    valor INT NOT NULL,
    tipo VARCHAR(10),
    descricao VARCHAR(10) NOT NULL,
    realizada_em timestamptz NULL
);

CREATE UNLOGGED TABLE transactions5 (
    id SERIAL,
    client_id INT,
    valor INT NOT NULL,
    tipo VARCHAR(10),
    descricao VARCHAR(10) NOT NULL,
    realizada_em timestamptz NULL
);

INSERT INTO "clients"("id", "limite", "balance") VALUES
    (1, 100000, 0),
    (2, 80000, 0),
    (3, 1000000, 0),
    (4, 10000000, 0),
    (5, 500000, 0);

CREATE OR REPLACE FUNCTION FindClient(idClient INT) 
RETURNS clients
LANGUAGE sql 
AS $$
    SELECT * FROM clients WHERE id = idClient FOR UPDATE;
$$
;


CREATE OR REPLACE FUNCTION add_transaction(idClient INT, valor INT, tipo CHAR, descricao VARCHAR(10))
RETURNS INT
LANGUAGE 'plpgsql'
AS $$
DECLARE
    novo_saldo INT;
BEGIN
    IF tipo = 'c' THEN
        UPDATE clients SET balance = balance + valor WHERE id = idClient
        RETURNING balance INTO novo_saldo;
    ELSE
        UPDATE clients SET balance = balance - valor WHERE id = idClient AND balance - valor  >= limite * -1
        RETURNING balance INTO novo_saldo;
    END IF;

    IF novo_saldo IS NOT NULL THEN
        case idClient
            WHEN 1 THEN
                INSERT INTO transactions1(valor, tipo, descricao, realizada_em)
                VALUES (valor, tipo, descricao, now());
            WHEN 2 THEN
                INSERT INTO transactions2(valor, tipo, descricao, realizada_em)
                VALUES (valor, tipo, descricao, now());
            WHEN 3 THEN
                INSERT INTO transactions3(valor, tipo, descricao, realizada_em)
                VALUES (valor, tipo, descricao, now());
            WHEN 4 THEN
                INSERT INTO transactions4(valor, tipo, descricao, realizada_em)
                VALUES (valor, tipo, descricao, now());
            ELSE
                INSERT INTO transactions5(valor, tipo, descricao, realizada_em)
                VALUES (valor, tipo, descricao, now());
            END CASE;
    END IF;

    RETURN novo_saldo;
END
$$;

-- Esquentando o banco pra diminuir o tempo inicial das requisicoes
-- Referencia do pq isso funciona https://littlekendra.com/2016/11/25/why-is-my-query-faster-the-second-time-it-runs-dear-sql-dba-episode-23/
SELECT * FROM clients;
SELECT * FROM transactions1;
SELECT * FROM transactions2;
SELECT * FROM transactions3;
SELECT * FROM transactions4;
SELECT * FROM transactions5;

SELECT * FROM add_transaction(1, 10, 'c', 'primeira');
SELECT * FROM transactions1;
SELECT * FROM add_transaction(2, 10, 'c', 'primeira');
SELECT * FROM transactions2;
SELECT * FROM add_transaction(3, 10, 'c', 'primeira');
SELECT * FROM transactions3;
SELECT * FROM add_transaction(4, 10, 'c', 'primeira');
SELECT * FROM transactions4;
SELECT * FROM add_transaction(5, 10, 'c', 'primeira');
SELECT * FROM transactions5;

DELETE FROM transactions1;
DELETE FROM transactions2;
DELETE FROM transactions3;
DELETE FROM transactions4;
DELETE FROM transactions5;

UPDATE clients SET balance=0;