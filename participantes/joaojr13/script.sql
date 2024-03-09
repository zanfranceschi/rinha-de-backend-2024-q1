CREATE UNLOGGED TABLE clientes (
    id SERIAL PRIMARY KEY,
    limite INTEGER NOT NULL,
    saldo INTEGER
);

CREATE UNLOGGED TABLE transacoes (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    valor INTEGER NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    data_ins TIMESTAMP NOT NULL
);

CREATE INDEX IDX_clientes_id ON clientes (id);
CREATE INDEX IDX_transacoes_cliente_id ON transacoes (cliente_id);

INSERT INTO clientes (id, limite, saldo) VALUES (1,100000, 0);
INSERT INTO clientes (id, limite, saldo) VALUES (2,80000, 0);
INSERT INTO clientes (id, limite, saldo) VALUES (3,1000000, 0);
INSERT INTO clientes (id, limite, saldo) VALUES (4,10000000, 0);
INSERT INTO clientes (id, limite, saldo) VALUES (5,500000, 0);