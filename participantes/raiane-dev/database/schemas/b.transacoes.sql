-- +migrate Up
CREATE TABLE IF NOT EXISTS transacoes (
        cliente_id INTEGER,
        tipo CHAR(1),
        valor INTEGER DEFAULT 0,
        descricao VARCHAR(10),
        realizado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY(cliente_id) REFERENCES clientes(id)
);