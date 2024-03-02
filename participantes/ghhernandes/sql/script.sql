CREATE UNLOGGED TABLE clientes (
    id integer PRIMARY KEY,
    limite integer NOT NULL,
    saldo integer NOT NULL
);

INSERT INTO clientes (id, saldo, limite)
VALUES
  (1, 0, 1000 * 100),
  (2, 0, 800 * 100),
  (3, 0, 10000 * 100),
  (4, 0, 100000 * 100),
  (5, 0, 5000 * 100);

CREATE UNLOGGED TABLE transacoes (
    id SERIAL PRIMARY KEY,
    cliente_id int NOT NULL,
    valor integer NOT NULL,
    descricao text,
    data timestamp without time zone default (now() at time zone 'utc')
);

CREATE INDEX idx_transacoes_cliente_id ON transacoes (cliente_id ASC);
CREATE INDEX idx_transacoes_data ON transacoes (data DESC);
