CREATE UNLOGGED TABLE cliente (
    id INT PRIMARY KEY,
    saldo INT NOT NULL,
    limite INT NOT NULL
);

CREATE UNLOGGED TABLE transacao (
    id SERIAL PRIMARY KEY,
    valor INT NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizado_em TIMESTAMP NOT NULL DEFAULT NOW(),
    cliente_id INT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

CREATE INDEX idx_cliente ON cliente(id) INCLUDE (saldo, limite);
CREATE INDEX idx_transacao_cliente ON transacao(cliente_id);

INSERT INTO cliente (Id, limite, saldo) VALUES
(1, 100000, 0),
(2, 80000, 0),
(3, 1000000, 0),
(4, 10000000, 0),
(5, 500000, 0);
