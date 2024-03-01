CREATE TABLE customers(
    Id INT PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Limite INT NOT NULL,
    Saldo INT NOT NULL DEFAULT 0
);

CREATE TABLE transactions(
    ClienteId INT NOT NULL,
    Tipo CHAR(1) NOT NULL,
    Descricao VARCHAR(10) NOT NULL,
    Valor INT NOT NULL DEFAULT 0,
    DataCriacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO customers(Id, Nome, Limite)
VALUES (1, 'o barato sai caro', 1000 * 100),
(2, 'zan corp ltda', 800 * 100),
(3, 'les cruders', 10000 * 100),
(4, 'padaria joia de cocaia', 100000 * 100),
(5, 'kid mais', 5000 * 100);