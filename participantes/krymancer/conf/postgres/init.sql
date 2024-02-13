CREATE TABLE cliente (
    id INT PRIMARY KEY,
    saldo INT NOT NULL,
    limite INT NOT NULL
);

CREATE TABLE transacao (
    id INT PRIMARY KEY,
    valor INT NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizado_em TIMESTAMP NOT NULL,
    cliente_id INT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

INSERT INTO cliente (Id, limite, saldo) VALUES
(1, 100000, 0),
(2, 80000, 0),
(3, 1000000, 0),
(4, 10000000, 0),
(5, 500000, 0);
