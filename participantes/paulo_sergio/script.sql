-- Create the clients table
CREATE UNLOGGED TABLE IF NOT EXISTS clients (
    id SERIAL PRIMARY KEY NOT NULL,
    limite INTEGER NOT NULL,
    saldo INTEGER NOT NULL
    );

-- Create the transactions table
CREATE UNLOGGED TABLE IF NOT EXISTS transactions (
    id SERIAL PRIMARY KEY NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    valor INTEGER NOT NULL,
    cliente_id INTEGER NOT NULL,
    realizada_em TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Create an index on cliente_id for performance optimization
CREATE INDEX idx_cliente_id ON transactions(cliente_id);

-- Insert initial data into clients
INSERT INTO clients (limite, saldo)
VALUES
    (100000, 0),
    (80000, 0),
    (1000000, 0),
    (10000000, 0),
    (500000, 0);
