CREATE DATABASE rinha2024q1;

\c rinha2024q1;

CREATE TABLE customers (
    id CHAR(1) PRIMARY KEY,
    limite INTEGER,
    saldo integer
);

CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    customer_id char(1) REFERENCES customers(id),
    valor INTEGER,
    tipo CHAR(1),
    descricao CHAR(10),
    realizada_em TIMESTAMP,
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE INDEX idx_customer_id_realizada_em ON transactions(customer_id, realizada_em);

INSERT INTO customers(id, limite, saldo) VALUES ('1', 100000, 0);
INSERT INTO customers(id, limite, saldo) VALUES ('2', 80000, 0);
INSERT INTO customers(id, limite, saldo) VALUES ('3', 1000000, 0);
INSERT INTO customers(id, limite, saldo) VALUES ('4', 10000000, 0);
INSERT INTO customers(id, limite, saldo) VALUES ('5', 500000, 0);

ALTER SYSTEM SET max_connections = 500;