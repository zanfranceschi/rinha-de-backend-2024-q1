CREATE UNLOGGED TABLE IF NOT EXISTS clientes (
    id SERIAL PRIMARY KEY,
    limite INTEGER NOT NULL,
    saldo INTEGER DEFAULT 0
);

CREATE UNLOGGED TABLE IF NOT EXISTS transacoes (
    cliente_id INTEGER NOT NULL REFERENCES clientes (id),
    valor INTEGER NOT NULL,
	realizada_em TIMESTAMPTZ DEFAULT now() NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	tipo CHAR(1) NOT NULL
);

CREATE INDEX transacao_order_idx ON transacoes USING btree (cliente_id, realizada_em DESC);

INSERT INTO clientes (limite, saldo) VALUES
    (1000 * 100, 0),
    (800 * 100, 0),
    (10000 * 100, 0),
    ( 100000 * 100, 0),
    (5000 * 100, 0);

-- Carregar a tabela clientes
SELECT pg_prewarm('clientes');

-- Carregar a tabela transacoes
SELECT pg_prewarm('transacoes');

-- Carregar o índice transacao_order_idx
SELECT pg_prewarm('transacao_order_idx');