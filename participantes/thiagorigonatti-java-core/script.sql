CREATE UNLOGGED TABLE tb_client
(
    id     BIGSERIAL PRIMARY KEY,
    limite BIGINT NOT NULL,
    saldo  BIGINT NOT NULL
);

CREATE UNLOGGED TABLE tb_transaction
(
    id           BIGSERIAL PRIMARY KEY,
    valor        BIGINT      NOT NULL,
    tipo         "char"      NOT NULL,
    descricao    VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMPTZ NOT NULL,
    client_id    BIGINT      NOT NULL,
    FOREIGN KEY (client_id) REFERENCES tb_client (id)
);

INSERT INTO tb_client (limite, saldo)
VALUES (100000, 0),
       (80000, 0),
       (1000000, 0),
       (10000000, 0),
       (500000, 0);
