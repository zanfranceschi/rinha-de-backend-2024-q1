
CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    limite BIGINT,
    saldo_inicial BIGINT
);

CREATE TABLE transacoes (
    id SERIAL PRIMARY KEY,
    cliente_id INT,
    valor BIGINT,
    tipo CHAR(1),
    descricao TEXT,
    realizada_em TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

INSERT INTO clientes (limite, saldo_inicial) VALUES
    (100000, 0),
    (80000, 0),
    (1000000, 0),
    (10000000, 0),
    (500000, 0);
