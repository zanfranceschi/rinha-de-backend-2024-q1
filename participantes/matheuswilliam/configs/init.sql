CREATE UNLOGGED TABLE IF NOT EXISTS cliente (
    id SERIAL PRIMARY KEY,
    limite INTEGER NOT NULL,
    nome VARCHAR(100) NOT NULL,
    saldo INTEGER DEFAULT 0
);

CREATE UNLOGGED TABLE IF NOT EXISTS transacao (
    cliente_id INTEGER NOT NULL REFERENCES cliente (id),
    valor INTEGER NOT NULL,
	realizada_em TIMESTAMP NOT NULL DEFAULT NOW(),
	descricao VARCHAR(10) NOT NULL,
	tipo CHAR(1) NOT NULL
);

CREATE INDEX idx_cliente_id ON cliente (id);
CREATE INDEX idx_realizada_em ON transacao (realizada_em);

INSERT INTO cliente (nome, limite) VALUES
    ('o barato sai caro', 1000 * 100),
    ('zan corp ltda', 800 * 100),
    ('les cruders', 10000 * 100),
    ('padaria joia de cocaia', 100000 * 100),
    ('kid mais', 5000 * 100);
