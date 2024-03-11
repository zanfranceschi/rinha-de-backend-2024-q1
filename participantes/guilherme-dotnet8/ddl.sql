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

DROP TABLE IF EXISTS cliente;
DROP TABLE IF EXISTS transacao;

CREATE TABLE cliente (
  id SERIAL PRIMARY KEY,
  limite INTEGER NOT NULL,
  saldo INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE transacao(
    id SERIAL PRIMARY KEY,
    valor  INTEGER NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    tipo CHAR NOT NULL,
    hora_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_cliente INTEGER NOT NULL
);

CREATE INDEX idx_customer_id ON cliente(id);

CREATE INDEX idx_transaction_customer_id ON transacao(id_cliente);

INSERT INTO cliente (limite, saldo)
VALUES
    (1000 * 100, 0),
    (800 * 100, 0),
    (10000 * 100, 0),
    (100000 * 100, 0),
    (5000 * 100, 0);


CREATE TYPE saldo_limite AS (
    saldo_cliente int4,
    limite_cliente int4,
    success bool
);

CREATE OR REPLACE FUNCTION criar_transacao_debito(valor INTEGER, id_cliente int4, descricao varchar(10))
RETURNS saldo_limite
LANGUAGE plpgsql 
AS $$
DECLARE
    result saldo_limite;
BEGIN
   UPDATE cliente SET saldo = saldo - valor WHERE id = id_cliente AND saldo - valor >= limite * (-1)
   RETURNING saldo, limite INTO result.saldo_cliente, result.limite_cliente;
   
   IF result.saldo_cliente >= result.limite_cliente * (-1) then
   		result.success := true;
		INSERT INTO transacao (valor, tipo, descricao,  id_cliente)
		VALUES(valor, 'd', descricao, id_cliente);
	else
		result.success := false;
   END IF;
   
   RETURN result;
END;
$$;

CREATE OR REPLACE FUNCTION criar_transacao_credito(valor INTEGER, id_cliente int4, descricao varchar(10))
RETURNS saldo_limite
LANGUAGE plpgsql 
AS $$
DECLARE
    result saldo_limite;
BEGIN
   UPDATE cliente SET saldo = saldo + valor WHERE id = id_cliente
   RETURNING saldo, limite INTO result.saldo_cliente, result.limite_cliente;

   result.success := true;
   
   INSERT INTO transacao (valor, tipo, descricao,  id_cliente)
   VALUES(valor, 'c', descricao, id_cliente);
   
   RETURN result;
END;
$$;