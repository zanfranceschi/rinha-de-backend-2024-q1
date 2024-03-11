CREATE DATABASE IF NOT EXISTS ContaBancaria;

USE ContaBancaria;

CREATE TABLE IF NOT EXISTS Clientes (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Limite INT NOT NULL,
    Saldo INT NOT NULL
) CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS Transacoes (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    ClienteId INT NOT NULL,
    Valor INT NOT NULL,
    Tipo VARCHAR(1) NOT NULL,
    Descricao TEXT NOT NULL,
    Realizada_Em DATETIME NOT NULL,
    CONSTRAINT FK_Transacoes_Clientes FOREIGN KEY (ClienteId) REFERENCES Clientes(Id)
) CHARSET=utf8mb4;

INSERT INTO Clientes (Id, Limite, Saldo) VALUES (1, 100000, 0);
INSERT INTO Clientes (Id, Limite, Saldo) VALUES (2, 80000, 0);
INSERT INTO Clientes (Id, Limite, Saldo) VALUES (3, 1000000, 0);
INSERT INTO Clientes (Id, Limite, Saldo) VALUES (4, 10000000, 0);
INSERT INTO Clientes (Id, Limite, Saldo) VALUES (5, 500000, 0);