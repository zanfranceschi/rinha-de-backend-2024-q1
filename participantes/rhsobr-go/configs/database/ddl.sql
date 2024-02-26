CREATE UNLOGGED TABLE clientes (
    id INTEGER PRIMARY KEY,
    limite INTEGER NOT NULL,
    saldo INTEGER NOT NULL DEFAULT 0,
    descricao_saldo_atual VARCHAR(10)
);

CREATE UNLOGGED TABLE transacoes (
    id INTEGER NOT NULL,
    cliente_id INTEGER NOT NULL,
    valor INTEGER NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP NOT NULL DEFAULT CLOCK_TIMESTAMP()
);

ALTER TABLE
    transacoes
ADD
    CONSTRAINT fk_cliente_id FOREIGN KEY (cliente_id) REFERENCES clientes (id);

CREATE INDEX IF NOT EXISTS idx_clientes_id ON clientes (id) INCLUDE(saldo, limite);

CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_transacoes ON transacoes (id, cliente_id);

CREATE INDEX IF NOT EXISTS idx_transacoes_cliente_id_realizada_em_desc ON transacoes (cliente_id, realizada_em DESC);