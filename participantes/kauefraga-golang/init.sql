CREATE TABLE IF NOT EXISTS clientes (
  id     SERIAL PRIMARY KEY,
  nome   TEXT NOT NULL,
  limite INTEGER NOT NULL,
  saldo  INTEGER NOT NULL DEFAULT 0
);

CREATE UNLOGGED TABLE IF NOT EXISTS transacoes (
  id           SERIAL PRIMARY KEY,
  valor        INTEGER NOT NULL,
  tipo         CHAR(1) NOT NULL,
  descricao    VARCHAR(10) NOT NULL,
  cliente_id   INTEGER NOT NULL,
  realizada_em TIMESTAMP NOT NULL DEFAULT NOW()
);

ALTER TABLE
  transacoes
  SET
    (autovacuum_enabled = false);

CREATE INDEX IF NOT EXISTS idx_transacoes ON transacoes (cliente_id);

INSERT INTO clientes (nome, limite)
VALUES
  ('o barato sai caro', 1000 * 100),
  ('zan corp ltda', 800 * 100),
  ('les cruders', 10000 * 100),
  ('padaria joia de cocaia', 100000 * 100),
  ('kid mais', 5000 * 100);
