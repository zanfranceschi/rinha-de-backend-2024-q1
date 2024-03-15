CREATE UNLOGGED TABLE IF NOT EXISTS clientes
(
    id     SERIAL PRIMARY KEY,
    nome   VARCHAR(22) NOT NULL,
    limite INTEGER     NOT NULL
);

CREATE UNLOGGED TABLE IF NOT EXISTS transacoes
(
    id           SERIAL8 PRIMARY KEY,
    cliente_id   INTEGER     NOT NULL,
    valor        INTEGER     NOT NULL,
    tipo         CHAR(1)     NOT NULL,
    descricao    VARCHAR(10) NOT NULL,
    saldo        INTEGER     NOT NULL,
    realizada_em TIMESTAMP   NOT NULL,

    FOREIGN KEY (cliente_id) REFERENCES clientes (id)
);

CREATE INDEX IF NOT EXISTS idx_transacoes_cliente_id ON transacoes (cliente_id);

DO
$$
    BEGIN
        INSERT INTO clientes (nome, limite)
        VALUES ('o barato sai caro', 1000 * 100),
               ('zan corp ltda', 800 * 100),
               ('les cruders', 10000 * 100),
               ('padaria joia de cocaia', 100000 * 100),
               ('kid mais', 5000 * 100);
    END;
$$
