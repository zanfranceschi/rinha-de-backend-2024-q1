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

CREATE UNLOGGED TABLE IF NOT EXISTS clientes(
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    limite INTEGER NOT NULL,
    saldo INTEGER DEFAULT 0 NOT NULL
    CONSTRAINT check_limit CHECK (saldo >= -limite)
);

CREATE UNLOGGED TABLE IF NOT EXISTS transacoes(
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes (id),
    valor INTEGER NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10),
    realizada_em TIMESTAMP DEFAULT current_timestamp
);

CREATE INDEX idx_cliente_id ON transacoes(cliente_id);

CREATE OR REPLACE FUNCTION create_transaction_trigger_function()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  v_limite INTEGER;
  v_saldo INTEGER;
BEGIN
  IF NEW.valor < 0 THEN
    RAISE EXCEPTION 'Transaction amount cannot be negative!';
  END IF;

  SELECT limite, saldo INTO v_limite, v_saldo FROM clientes WHERE id = NEW.cliente_id;

  IF NEW.tipo = 'c' THEN
    UPDATE clientes SET saldo = saldo + NEW.valor WHERE id = NEW.cliente_id;
  ELSIF NEW.tipo = 'd' THEN
    IF (v_saldo + v_limite - NEW.valor) < 0 THEN
      RAISE EXCEPTION 'Debit exceeds customer limit and balance!';
    ELSE
      UPDATE clientes SET saldo = saldo - NEW.valor WHERE id = NEW.cliente_id;
    END IF;
  ELSE
    RAISE EXCEPTION 'Invalid transaction!';
  END IF;

  RETURN NEW;
END;
$$;

CREATE TRIGGER create_transaction_trigger
BEFORE INSERT
ON transacoes
FOR EACH ROW
EXECUTE FUNCTION create_transaction_trigger_function();

DO $$
BEGIN
  INSERT INTO clientes (nome, limite)
  VALUES
    ('o barato sai caro', 1000 * 100),
    ('zan corp ltda', 800 * 100),
    ('les cruders', 10000 * 100),
    ('padaria joia de cocaia', 100000 * 100),
    ('kid mais', 5000 * 100);
END;
$$;
