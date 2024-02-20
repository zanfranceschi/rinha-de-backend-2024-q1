CREATE TABLE IF NOT EXISTS clientes (
  id SERIAL PRIMARY KEY,
  limite INT NOT NULL,
  saldo INT NOT NULL DEFAULT 0
);

CREATE TYPE tipo_transacao AS ENUM ('c', 'd');

CREATE TABLE IF NOT EXISTS transacoes (
  id SERIAL PRIMARY KEY,
  valor INT NOT NULL,
  tipo tipo_transacao NOT NULL,
  descricao VARCHAR(10) CHECK (LENGTH(descricao) >= 1),
  realizada_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  cliente_id INT REFERENCES clientes (id) ON DELETE CASCADE
);
