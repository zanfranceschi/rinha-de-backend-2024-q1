CREATE UNLOGGED TABLE clientes (
    id SERIAL PRIMARY KEY,
    limite INTEGER NOT NULL,
    saldo INTEGER NOT NULL,
    transacoes TEXT NOT NULL DEFAULT '[]'
);

CREATE UNIQUE INDEX idx_clientes_id ON clientes USING btree (id);

INSERT INTO clientes (limite, saldo)
VALUES
    (100000, 0),
    (80000, 0),
    (1000000, 0),
    (10000000, 0),
    (500000, 0);