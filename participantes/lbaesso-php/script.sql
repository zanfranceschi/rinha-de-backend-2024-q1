-- Drop tables and recreate them

DROP TABLE IF EXISTS transacoes;
DROP TABLE IF EXISTS clientes;

CREATE UNLOGGED TABLE clientes (
    id integer PRIMARY KEY,
    nome varchar(100),
    limite int,
    saldo int
);

CREATE INDEX idx_clientes_id ON clientes (id);
CREATE INDEX idx_clientes_saldo ON clientes (saldo);
CREATE INDEX idx_clientes_limite ON clientes (limite);

CREATE UNLOGGED TABLE transacoes (
    id SERIAL PRIMARY KEY,
    clienteid integer,
    clientenome varchar(100),
    valor int,
    tipo char(1),
    descricao varchar(10),
    datahora timestamp DEFAULT CURRENT_TIMESTAMP,
    ultimolimite int,
    ultimosaldo int
);

CREATE INDEX idx_transacoes_id ON transacoes (id DESC);
CREATE INDEX idx_transacoes_clienteid ON transacoes (clienteid);

INSERT INTO clientes (id, nome, limite, saldo)
  VALUES
    (1, 'o barato sai caro', 1000 * 100, 0),
    (2, 'zan corp ltda', 800 * 100, 0),
    (3, 'les cruders', 10000 * 100, 0),
    (4, 'padaria joia de cocaia', 100000 * 100, 0),
    (5, 'kid mais', 5000 * 100, 0);

INSERT INTO transacoes (clienteid, valor, tipo, descricao, clientenome, ultimolimite, ultimosaldo)
  SELECT id, 0, 'c', 'inicial', nome, limite, saldo FROM clientes;