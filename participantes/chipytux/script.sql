CREATE UNLOGGED TABLE customer
(
    id SERIAL PRIMARY KEY,
    limite BIGINT NOT NULL,
    saldo  BIGINT NOT NULL
);

CREATE UNLOGGED TABLE transaction
(
    id SERIAL PRIMARY KEY,
    customer_id  INT     NOT NULL,
    valor        BIGINT     NOT NULL,
    tipo         CHAR(1)     NOT NULL,
    descricao    VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP   NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_customer_id
        FOREIGN KEY (customer_id) REFERENCES customer (id)
);


BEGIN;

INSERT INTO customer(id, limite, saldo)
VALUES (1, 100000, 0),
       (2, 80000, 0),
       (3, 1000000, 0),
       (4, 10000000, 0),
       (5, 500000, 0);
COMMIT;
