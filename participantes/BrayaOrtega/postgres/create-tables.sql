-- Table definition for Transaction entity
CREATE TABLE IF NOT EXISTS Transactions (
    Id SERIAL PRIMARY KEY,
    AccountId INT NOT NULL,
    Descricao VARCHAR(10),
    Tipo CHAR(1) NOT NULL,
    Valor INTEGER NOT NULL,
    Saldo INTEGER NOT NULL,
    Limite INTEGER NOT NULL,
    RealizadaEm TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_transactions_accountid ON Transactions (AccountId);

CREATE INDEX idx_transactions_accountId_realizadaem ON Transactions (AccountId, RealizadaEm);