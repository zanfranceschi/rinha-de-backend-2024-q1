-- A table for storing/updating all client's data.
-- A single entry per client.
CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    limite INTEGER NOT NULL,
    saldo INTEGER NOT NULL DEFAULT 0 CHECK (saldo >= -limite)
);

-- A table for storing the transactions executed by all clients.
-- Multiple entries for each client.
CREATE TABLE transacoes (
    id INTEGER REFERENCES clientes(id),
    valor INTEGER NOT NULL,
    tipo VARCHAR(1) NOT NULL,
    descricao VARCHAR(10),
    realizada_em TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO clientes (limite) 
VALUES 
    (100000),
    (80000),
    (1000000),
    (10000000),
    (500000);