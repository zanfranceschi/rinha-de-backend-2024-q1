CREATE TABLE IF NOT EXISTS clientes(
    id     BIGSERIAL PRIMARY KEY,
    limite BIGINT NOT NULL,
    saldo  BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS transacoes(
    id           BIGSERIAL PRIMARY KEY,
    cliente_id   BIGINT NOT NULL,
    valor        BIGINT NOT NULL,
    tipo         CHAR(1) NOT NULL,
    descricao    VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

INSERT INTO clientes(limite) VALUES (100000);
INSERT INTO clientes(limite) VALUES (80000);
INSERT INTO clientes(limite) VALUES (1000000);
INSERT INTO clientes(limite) VALUES (10000000);
INSERT INTO clientes(limite) VALUES (500000);

CREATE INDEX IF NOT EXISTS clientes_id_idx ON clientes(id);
CREATE INDEX IF NOT EXISTS transacoes_cliente_id_idx ON transacoes(cliente_id);
CREATE INDEX IF NOT EXISTS transacoes_realizada_em_idx ON transacoes(realizada_em);
