CREATE UNLOGGED TABLE clientes (
    id BIGSERIAL PRIMARY KEY NOT NULL,
    created_at timestamp with time zone,
    limite bigint,
    saldo bigint
);

CREATE UNLOGGED TABLE transacoes (
    id BIGSERIAL PRIMARY KEY NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    valor bigint,
    tipo char(1),
    descricao char(10),
    cliente_id bigint
);

CREATE UNIQUE INDEX idx_cliente ON clientes (id);
CREATE INDEX idx_transacao_created_at ON transacoes (created_at DESC);

INSERT INTO clientes (limite, saldo) VALUES
  (100000, 0),
  (80000, 0),
  (1000000, 0),
  (10000000, 0),
  (500000, 0);
