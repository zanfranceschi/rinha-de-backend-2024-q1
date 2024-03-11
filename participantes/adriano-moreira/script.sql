CREATE TABLE clientes
(
    id     SERIAL PRIMARY KEY,
    nome   VARCHAR(32),
    limite NUMERIC DEFAULT 0,
    saldo  NUMERIC DEFAULT 0,
    version NUMERIC DEFAULT 1
);

CREATE TABLE transacoes
(
    id         SERIAL PRIMARY KEY,
    cliente_id numeric     NOT NULL,
    tipo       char        NOT NULL,
    valor      numeric     NOT NULL,
    descricao  VARCHAR(10) NOT NULL,
    criado     timestamp DEFAULT NOW()
);


INSERT INTO clientes (nome, limite)
VALUES ('o barato sai caro', 1000 * 100),
       ('zan corp ltda', 800 * 100),
       ('les cruders', 10000 * 100),
       ('padaria joia de cocaia', 100000 * 100),
       ('kid mais', 5000 * 100);
