CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    limite INT NOT NULL CHECK (limite > 0),
    saldo INT NOT NULL DEFAULT 0
);

CREATE TABLE transacoes (
    id SERIAL PRIMARY KEY,
    valor INT NOT NULL CHECK (valor > 0),
    tipo CHAR(1) NOT NULL CHECK (tipo IN ('c', 'd')),
    descricao VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_cliente INT,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);

CREATE INDEX idx_transacoes_id_cliente ON transacoes(id_cliente);

INSERT INTO clientes (id, limite, saldo) VALUES
(1, 100000, 0),
(2, 80000, 0),
(3, 1000000, 0),
(4, 10000000, 0),
(5, 500000, 0);
