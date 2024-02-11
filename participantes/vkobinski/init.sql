DROP TABLE IF EXISTS cliente;
DROP TABLE IF EXISTS saldo;
DROP TABLE IF EXISTS transacao;

CREATE TABLE cliente (
    cliente_id SERIAL PRIMARY KEY

);

CREATE TABLE saldo (
    saldo_id SERIAL PRIMARY KEY,
    cliente_id SERIAL,
    total INT NOT NULL,
    limite INT NOT NULL,
    CONSTRAINT fk_cliente
        FOREIGN KEY(cliente_id)
            REFERENCES cliente(cliente_id)
);

CREATE TABLE transacao (
    transacao_id SERIAL PRIMARY KEY,
    cliente_id SERIAL,
    valor INT NOT NULL,
    tipo VARCHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMPTZ NOT NULL,
    CONSTRAINT fk_transacao_cliente
        FOREIGN KEY(cliente_id)
            REFERENCES cliente(cliente_id)
);

INSERT INTO cliente DEFAULT VALUES;
INSERT INTO cliente DEFAULT VALUES;
INSERT INTO cliente DEFAULT VALUES;
INSERT INTO cliente DEFAULT VALUES;
INSERT INTO cliente DEFAULT VALUES;

INSERT INTO saldo (cliente_id, limite, total) VALUES (1, 100000, 0);
INSERT INTO saldo (cliente_id, limite, total) VALUES (2, 80000, 0);
INSERT INTO saldo (cliente_id, limite, total) VALUES (3, 1000000, 0);
INSERT INTO saldo (cliente_id, limite, total) VALUES (4, 10000000, 0);
INSERT INTO saldo (cliente_id, limite, total) VALUES (5, 500000, 0);
