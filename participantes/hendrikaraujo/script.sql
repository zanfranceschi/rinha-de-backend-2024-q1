SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;

CREATE UNLOGGED TABLE clientes (
    id SERIAL PRIMARY KEY NOT NULL,
    nome VARCHAR(50) NOT NULL,
    limite INTEGER NOT NULL,
    saldo INTEGER NOT NULL
);

CREATE UNLOGGED TABLE transacoes (
    id SERIAL PRIMARY KEY NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    valor INTEGER NOT NULL,
    cliente_id INTEGER NOT NULL,
    realizada_em TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_cliente_id ON transacoes (cliente_id);

INSERT INTO clientes (nome, limite, saldo)
VALUES
('o barato sai caro', 1000 * 100, 0),
('zan corp ltda', 800 * 100, 0),
('les cruders', 10000 * 100, 0),
('padaria joia de cocaia', 100000 * 100, 0),
('kid mais', 5000 * 100, 0);
