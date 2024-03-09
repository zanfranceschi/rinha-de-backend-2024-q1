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

CREATE UNLOGGED TABLE saldo_cliente (
    id SERIAL PRIMARY KEY NOT NULL,
    id_cliente INTEGER NOT NULL,
    saldo INTEGER NOT NULL,
    limite INTEGER NOT NULL
);
CREATE UNIQUE INDEX idx_cliente_id_cliente ON saldo_cliente (id_cliente);

CREATE UNLOGGED TABLE transacao_cliente (
    id SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL,
    valor INTEGER NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC')
);
CREATE INDEX idx_transacao_cliente_id_cliente ON transacao_cliente (id_cliente);

DO $$
    BEGIN
        INSERT INTO saldo_cliente (id_cliente, saldo, limite)
        VALUES (1, 0,   1000 * 100),
               (2, 0,    800 * 100),
               (3, 0,  10000 * 100),
               (4, 0, 100000 * 100),
               (5, 0,   5000 * 100);
    END;
$$;

CREATE OR REPLACE FUNCTION atualiza_saldo_cliente_and_insere_transacao(
    p_id_cliente INT,
    p_valor INT,
    p_descricao VARCHAR(10),
    p_tipo CHAR(1))
    RETURNS TABLE (saldo_atualizado INT, limite_atual INT, linhas_afetadas INT)
AS $$
DECLARE
    v_saldo INT = 0;
    v_limite INT = 0;
    v_linhas_afetadas INT = 0;
BEGIN

    PERFORM pg_advisory_xact_lock(p_id_cliente);
    SELECT saldo, limite INTO v_saldo, v_limite FROM saldo_cliente WHERE id_cliente = p_id_cliente;

    IF p_tipo = 'c' THEN
        v_saldo = v_saldo + p_valor;
        UPDATE saldo_cliente SET saldo = v_saldo WHERE id_cliente = p_id_cliente;
        GET diagnostics v_linhas_afetadas = row_count;
    ELSE
        v_saldo = v_saldo - p_valor;
        UPDATE saldo_cliente SET saldo = v_saldo WHERE id_cliente = p_id_cliente AND abs(saldo - p_valor) <= limite;
        GET diagnostics v_linhas_afetadas = row_count;
    END IF;

    IF v_linhas_afetadas > 0 THEN
        INSERT INTO transacao_cliente(id_cliente, valor, tipo, descricao, realizada_em)
        VALUES (p_id_cliente, p_valor, p_tipo, p_descricao, NOW());
    END IF;

    -- RETURN QUERY SELECT v_saldo, v_limite, v_linhas_afetadas;
    RETURN QUERY SELECT saldo AS saldo_atualizado, limite AS limite_atual, v_linhas_afetadas AS linhas_afetadas FROM saldo_cliente WHERE id_cliente = p_id_cliente;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION obter_extrato_cliente(p_id_cliente INT)
    RETURNS TABLE (
                      limite INT,
                      valor INT,
                      tipo CHAR(1),
                      descricao VARCHAR(10),
                      data TIMESTAMP)
    LANGUAGE sql
AS $$
(SELECT limite       AS limite
      , saldo        AS valor
      , NULL         AS tipo
      , NULL         AS descricao
      , NOW()        AS data
 FROM saldo_cliente
 WHERE id_cliente = p_id_cliente
 LIMIT 1)
UNION ALL
(SELECT NULL         AS limite
      , valor        AS valor
      , tipo         AS tipo
      , descricao    AS descricao
      , realizada_em AS data
 FROM transacao_cliente
 WHERE id_cliente = p_id_cliente
 ORDER BY id DESC
 LIMIT 10)
$$;