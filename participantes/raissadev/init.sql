CREATE UNLOGGED TABLE IF NOT EXISTS clientes (
    id SERIAL PRIMARY KEY NOT NULL
,   nome VARCHAR(100) NOT NULL
,   limite INT NOT NULL
,   saldo INT
);

CREATE UNLOGGED TABLE IF NOT EXISTS transacoes (
    id SERIAL PRIMARY KEY NOT NULL
,   id_cliente INT NOT NULL
,   valor INT NOT NULL
,   tipo VARCHAR(1) NOT NULL
,   descricao VARCHAR(100) NOT NULL
,   realizada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
,   FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);

-- CREATE INDEX idx_id_cliente ON transacoes (id_cliente);

DO $$
BEGIN
  INSERT INTO clientes (nome, limite)
  VALUES
    ('o barato sai caro', 1000 * 100),
    ('zan corp ltda', 800 * 100),
    ('les cruders', 10000 * 100),
    ('padaria joia de cocaia', 100000 * 100),
    ('kid mais', 5000 * 100);
END; $$