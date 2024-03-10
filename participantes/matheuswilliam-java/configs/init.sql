CREATE UNLOGGED TABLE IF NOT EXISTS cliente (
    id SERIAL PRIMARY KEY,
    limite INTEGER NOT NULL,
    saldo INTEGER DEFAULT 0
);

CREATE UNLOGGED TABLE IF NOT EXISTS transacao (
    cliente_id INTEGER NOT NULL REFERENCES cliente (id),
    valor INTEGER NOT NULL,
	realizada_em TIMESTAMPTZ DEFAULT now() NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	tipo CHAR(1) NOT NULL
);

CREATE INDEX transacao_idx ON transacao USING btree (cliente_id, realizada_em);

INSERT INTO cliente (limite, saldo) VALUES
    (1000 * 100, 0),
    (800 * 100, 0),
    (10000 * 100, 0),
    ( 100000 * 100, 0),
    (5000 * 100, 0);
