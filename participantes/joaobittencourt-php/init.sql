CREATE TABLE IF NOT EXISTS clientes (
    id SERIAL PRIMARY KEY,
    limite INT,
    saldo INT
);

CREATE TABLE IF NOT EXISTS transacoes (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    valor INTEGER,
    tipo CHAR(1),
    descricao VARCHAR(10),
    realizada_em VARCHAR(27)
);

CREATE INDEX IF NOT EXISTS idx_cliente_id ON transacoes(cliente_id);
CREATE INDEX IF NOT EXISTS idx_realizada_em ON transacoes(realizada_em);

INSERT INTO clientes (limite, saldo)
VALUES
    (  100000, 0),
    (   80000, 0),
    ( 1000000, 0),
    (10000000, 0),
    (  500000, 0);