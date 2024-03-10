-- Coloque scripts iniciais aqui
CREATE TABLE IF NOT EXISTS clientes
(
    id     SERIAL,
    limite INTEGER,
    saldo  INTEGER DEFAULT 0
);

CREATE UNIQUE INDEX IF NOT EXISTS clientes_id_idx ON clientes (id);

INSERT INTO clientes (limite)
VALUES (1000 * 100),
       (800 * 100),
       (10000 * 100),
       (100000 * 100),
       (5000 * 100);
END;

CREATE TABLE IF NOT EXISTS transacoes
(
    id           SERIAL,
    cliente_id   INTEGER,
    valor        INTEGER,
    tipo         CHAR(1),
    descricao    VARCHAR(10),
    realizada_em TIMESTAMP DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS transacoes_id_idx ON transacoes (id);