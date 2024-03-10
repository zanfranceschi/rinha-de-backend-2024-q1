CREATE TABLE clientes (id SERIAL PRIMARY KEY, limite INT NOT NULL, saldo INT NOT NULL);

INSERT INTO clientes (id, limite, saldo) VALUES (1, 100000, 0);
INSERT INTO clientes (id, limite, saldo) VALUES (2, 80000, 0);
INSERT INTO clientes (id, limite, saldo) VALUES (3, 1000000, 0);
INSERT INTO clientes (id, limite, saldo) VALUES (4, 10000000, 0);
INSERT INTO clientes (id, limite, saldo) VALUES (5, 500000, 0);

CREATE TABLE transacoes (
    cliente_id INT NOT NULL, 
    tipo CHAR NOT NULL, 
    descricao VARCHAR(10) NOT NULL, 
    valor INT NOT NULL, 
    realizada_em TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc', now()) NOT NULL,
    CONSTRAINT fk_clientes FOREIGN KEY(cliente_id) REFERENCES clientes(id)
);

CREATE INDEX idx_client_id ON transacoes(cliente_id);