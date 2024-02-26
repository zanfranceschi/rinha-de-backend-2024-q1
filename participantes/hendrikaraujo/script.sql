CREATE TABLE clientes (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
    nome VARCHAR(50) NOT NULL,
    limite INTEGER NOT NULL,
    saldo INTEGER NOT NULL
);

CREATE TABLE transacoes (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
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
