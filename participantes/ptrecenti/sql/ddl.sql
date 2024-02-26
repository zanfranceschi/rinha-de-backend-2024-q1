CREATE TABLE clientes
(
    id     SERIAL PRIMARY KEY,
    nome   VARCHAR(50) NOT NULL,
    limite INTEGER     NOT NULL
);

CREATE TABLE transacoes
(
    id           SERIAL PRIMARY KEY,
    cliente_id   INTEGER     NOT NULL,
    valor        INTEGER     NOT NULL,
    tipo         CHAR(1)     NOT NULL,
    descricao    VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP   NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_clientes_transacoes_id
        FOREIGN KEY (cliente_id) REFERENCES clientes (id)
);

CREATE INDEX i_cliente_realizada_em
    ON transacoes (cliente_id, realizada_em);


CREATE TABLE saldos
(
    id         SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    valor      INTEGER NOT NULL,
    versao     INTEGER NOT NULL,
    CONSTRAINT fk_clientes_saldos_id
        FOREIGN KEY (cliente_id) REFERENCES clientes (id)
);