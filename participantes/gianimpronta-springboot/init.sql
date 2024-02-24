CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE UNLOGGED TABLE IF NOT EXISTS clientes
(
    id BIGSERIAL NOT NULL,
    limite BIGINT NOT NULL,
    saldo BIGINT NOT NULL,
    CONSTRAINT pk_clientes PRIMARY KEY (id)
);
create index clientes_id_idx
    on clientes (id);

CREATE UNLOGGED TABLE transacoes
(
    id BIGSERIAL NOT NULL,
    valor      BIGINT                      NOT NULL,
    tipo       CHAR                        NOT NULL,
    descricao  VARCHAR(10)                 NOT NULL,
    realizacao TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    cliente_id BIGINT                      NOT NULL,
    CONSTRAINT pk_transacoes PRIMARY KEY (id)
);
ALTER TABLE transacoes
    ADD CONSTRAINT FK_TRANSACOES_ON_CLIENTE FOREIGN KEY (cliente_id) REFERENCES clientes (id);


truncate table transacoes cascade;
truncate table clientes cascade;

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