CREATE TABLE clientes
(
    id      INT PRIMARY KEY,
    limite  INTEGER     NOT NULL
);
CREATE INDEX id_cliente ON clientes USING HASH (id);

INSERT INTO clientes (id, limite)
VALUES  (1, 100000),
        (2, 80000),
        (3, 1000000),
        (4, 10000000),
        (5, 500000);

CREATE TABLE saldos
(
    cliente_id  INTEGER     NOT NULL,
    balanco     INTEGER     NOT NULL DEFAULT 0,
    limite      INTEGER     NOT NULL DEFAULT 0,
    criado_em   TIMESTAMP   NOT NULL DEFAULT NOW(),
    CHECK (balanco >= (limite * -1))
);
CREATE INDEX saldos_cliente_id_idx ON public.saldos USING btree (cliente_id, criado_em DESC);

INSERT INTO saldos (cliente_id, limite)
SELECT id, limite FROM clientes;

CREATE TABLE transacoes
(
    cliente_id  INTEGER     NOT NULL,
    valor       INTEGER     NOT NULL,
    operacao    CHAR(1)     NOT NULL,
    descricao   VARCHAR(10) NOT NULL,
    criado_em   TIMESTAMP   NOT NULL DEFAULT NOW()
);
CREATE INDEX transacoes_cliente_id_idx ON public.transacoes (cliente_id,criado_em DESC);

CREATE USER api01 WITH PASSWORD 'api01_pass';
CREATE USER api02 WITH PASSWORD 'api02_pass';

GRANT ALL ON DATABASE rinha_db TO api01;
GRANT ALL ON ALL TABLES IN SCHEMA public TO api01;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO api01;

GRANT ALL ON DATABASE rinha_db TO api02;
GRANT ALL ON ALL TABLES IN SCHEMA public TO api02;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO api02;
