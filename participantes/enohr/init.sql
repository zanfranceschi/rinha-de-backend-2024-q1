CREATE UNLOGGED TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY,
    limite INTEGER NOT NULL,
    saldo INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT chk_limite CHECK (-saldo <= limite)
);

CREATE UNLOGGED TABLE IF NOT EXISTS transacoes (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    valor INTEGER NOT NULL,
    tipo VARCHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE INDEX idx_transacoes_realizada_em ON transacoes(realizada_em DESC, user_id);
CREATE INDEX idx_transacoes_user_id ON transacoes(user_id);

INSERT INTO users(id, limite)
VALUES 
    (1, 100000),
    (2, 80000),
    (3, 1000000),
    (4, 10000000),
    (5, 500000)
