SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;
SET default_tablespace = '';
SET default_table_access_method = heap;

CREATE UNLOGGED TABLE IF NOT EXISTS clientes (
  id SMALLINT PRIMARY KEY,
  limite INT NOT NULL,
  saldo INT NOT NULL DEFAULT 0
  CONSTRAINT saldo CHECK (saldo > -limite)
);

CREATE INDEX pk_cliente_idx ON clientes (id) INCLUDE (saldo);

INSERT INTO clientes (id, limite)
VALUES (1, 1000 * 100),
       (2, 800 * 100),
       (3, 10000 * 100),
       (4, 100000 * 100),
       (5, 5000 * 100)
ON CONFLICT DO NOTHING;

CREATE UNLOGGED TABLE IF NOT EXISTS transacoes (
  id SERIAL PRIMARY KEY,
  cliente_id SMALLINT NOT NULL,
  valor INT NOT NULL,
  tipo CHAR(1) NOT NULL,
  descricao VARCHAR(10) NOT NULL,
  realizada_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  FOREIGN KEY (cliente_id) REFERENCES clientes (id)
);

CREATE INDEX idx_transacoes_cliente_id ON transacoes (cliente_id, id DESC);

CREATE OR REPLACE PROCEDURE adiciona_transacao(
  id_cliente SMALLINT,
  valor INTEGER,
  valor_extrato INTEGER, 
  tipo CHAR(1),
  descricao VARCHAR(10),
  OUT saldo_atual INTEGER,
  OUT limite_atual INTEGER
)
LANGUAGE plpgsql AS
$$
BEGIN
  INSERT INTO transacoes (cliente_id, valor, tipo, descricao) VALUES (id_cliente, valor, tipo, descricao);

  UPDATE clientes
     SET saldo = saldo + valor_extrato
   WHERE id = id_cliente RETURNING saldo, limite INTO saldo_atual, limite_atual;

  COMMIT;
  RETURN;
END;
$$;