ALTER SYSTEM SET TIMEZONE TO 'UTC';

SELECT 'CREATE DATABASE FMDB'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'FMDB')\gexec


CREATE TABLE ClientTB(
    id              INTEGER PRIMARY KEY,
    limite          INTEGER NOT NULL,
    saldo           INTEGER NOT NULL
);

CREATE TABLE TransactionTB(
    id              SERIAL PRIMARY KEY ,
    valor           INTEGER NOT NULL,
    tipo            CHAR(1),
    descricao       VARCHAR(10) NOT NULL,
    realizada_em    TIMESTAMPTZ,
    user_id          INTEGER REFERENCES ClientTB(id)
);

INSERT INTO ClientTB (id, limite, saldo) 
VALUES 
    (1, 100000, 0), 
    (2, 80000, 0),
    (3, 1000000, 0),
    (4, 10000000, 0),
    (5, 500000, 0);
