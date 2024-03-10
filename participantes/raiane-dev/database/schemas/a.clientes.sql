-- +migrate Up
CREATE TABLE IF NOT EXISTS clientes (
    id INTEGER PRIMARY KEY,
    nome VARCHAR(50),
    limite INTEGER,
    saldo INTEGER DEFAULT 0,
    saldo_inicial INTEGER DEFAULT 0
);