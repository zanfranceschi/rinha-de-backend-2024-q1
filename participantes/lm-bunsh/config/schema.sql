CREATE TABLE IF NOT EXISTS Clientes (
    id INTEGER PRIMARY KEY,
    saldo INTEGER,
    limite INTEGER
);

CREATE TABLE IF NOT EXISTS Transacoes (
    id INTEGER PRIMARY KEY,
    valor INTEGER,
    tipo VARCHAR(1),
    descricao VARCHAR(10),
    clienteId INTEGER,
    realizada_em DATE,
    FOREIGN KEY (clienteId) REFERENCES Clientes(id)
);

INSERT OR IGNORE INTO Clientes (id, saldo, limite) VALUES (1, 0, 100000);
INSERT OR IGNORE INTO Clientes (id, saldo, limite) VALUES (2, 0, 80000);
INSERT OR IGNORE INTO Clientes (id, saldo, limite) VALUES (3, 0, 1000000);
INSERT OR IGNORE INTO Clientes (id, saldo, limite) VALUES (4, 0, 10000000);
INSERT OR IGNORE INTO Clientes (id, saldo, limite) VALUES (5, 0, 500000);