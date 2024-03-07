CREATE UNLOGGED TABLE IF NOT EXISTS cliente (
    id SERIAL PRIMARY KEY NOT NULL,
    limite INTEGER,
    saldo INTEGER
);

CREATE UNLOGGED TABLE IF NOT EXISTS transacao (
    id SERIAL PRIMARY KEY NOT NULL,
    tipo CHAR(1),
    descricao VARCHAR(10),
    valor INTEGER,
    cliente_id INTEGER NOT NULL,
    realizada_em VARCHAR(70)
);

CREATE INDEX IF NOT EXISTS idx_cliente_id ON transacao (cliente_id);

CREATE INDEX IF NOT EXISTS idx_realizada_em ON transacao (realizada_em);

CREATE EXTENSION IF NOT EXISTS pg_prewarm;

SELECT pg_prewarm('cliente');

SELECT pg_prewarm('transacao');

INSERT INTO cliente (limite, saldo)
VALUES
    (100000, 0),
    ( 80000, 0),
    (1000000, 0),
    (10000000, 0),
    (500000, 0);