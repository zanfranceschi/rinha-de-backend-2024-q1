CREATE UNLOGGED TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    limite INTEGER NOT NULL,
    saldo INTEGER NOT NULL DEFAULT 0
);

CREATE UNLOGGED TABLE transacoes (
    id SERIAL PRIMARY KEY,
    valor INTEGER NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP NOT NULL,
    cliente_id INTEGER NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes (id)
);

CREATE INDEX idx_cliente_id_realizada_em ON transacoes (cliente_id, realizada_em DESC);

DO $$
BEGIN
  INSERT INTO clientes (id, nome, limite)
  VALUES
    (1, 'o barato sai caro', 100000),
    (2, 'zan corp ltda', 80000),
    (3, 'les cruders', 1000000),
    (4, 'padaria joia de cocaia', 10000000),
    (5, 'kid mais', 500000);
END; $$
