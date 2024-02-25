\c rinha

CREATE TABLE clientes (
    id     SMALLSERIAL PRIMARY KEY,
    limite INTEGER,
    saldo  INTEGER CHECK (saldo >= -limite) NOT NULL
);
CREATE INDEX idx_clientes_id ON clientes (id);

CREATE TABLE transacoes (
    id           SERIAL PRIMARY KEY,
    valor        INTEGER,
    tipo         CHAR(1),
    descricao    VARCHAR(10),
    realizada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cliente_id   SMALLINT REFERENCES clientes (id),
    CONSTRAINT fk_transacoes_clientes FOREIGN KEY (cliente_id) REFERENCES clientes (id)
);
CREATE INDEX idx_transacoes_cliente_id_realizada_em ON transacoes (cliente_id, realizada_em);

INSERT INTO clientes (limite, saldo)
VALUES
    (100000, 0),
    (80000, 0),
    (1000000, 0),
    (10000000, 0),
    (500000, 0);
