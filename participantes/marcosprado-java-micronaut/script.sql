CREATE UNLOGGED TABLE clientes (
    id BIGINT PRIMARY KEY,
    limite INTEGER NOT NULL,
    saldo INTEGER NOT NULL DEFAULT 0
);

CREATE UNLOGGED TABLE transacoes (
    id SERIAL PRIMARY KEY,
    valor INTEGER NOT NULL,
    cliente_id BIGINT NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP,
    CONSTRAINT fk_cliente_transacoes_id
        FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE INDEX idx_clientes_id ON clientes (id) INCLUDE (limite, saldo);
CREATE INDEX idx_transacoes_clientes_id ON transacoes (cliente_id);
CREATE INDEX idx_transacoes_clientes_id_realizda_em ON transacoes (cliente_id, realizada_em DESC);

DO $$
BEGIN
    INSERT INTO clientes (id, limite)
    VALUES (1, 1000 * 100), (2, 800 * 100), (3, 10000 * 100), (4, 100000 * 100), (5, 5000 * 100);
END;
$$;
