SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET check_function_bodies = false;
SET row_security = off;
SET default_table_access_method = heap;

CREATE UNLOGGED TABLE cliente (
    id SERIAL PRIMARY KEY,
    saldo integer NOT NULL,
    limite integer NOT NULL
);

CREATE UNLOGGED TABLE transacao (
    id SERIAL PRIMARY KEY,
    valor integer NOT NULL,
    tipo varchar(1) NOT NULL,
    descricao varchar(10) NOT NULL,
    realizada_em timestamp NOT NULL DEFAULT (now()),
    cliente_id integer NOT NULL
);

CREATE INDEX idx_cliente_id ON transacao(cliente_id);
CREATE INDEX idx_realizada_em ON transacao(realizada_em);

INSERT INTO cliente (id, limite, saldo) VALUES (1, 100000, 0);
INSERT INTO cliente (id, limite, saldo) VALUES (2, 80000, 0);
INSERT INTO cliente (id, limite, saldo) VALUES (3, 1000000, 0);
INSERT INTO cliente (id, limite, saldo) VALUES (4, 10000000, 0);
INSERT INTO cliente (id, limite, saldo) VALUES (5, 500000, 0);

CREATE OR REPLACE FUNCTION criar_transacao(cliente_id integer, valor integer, descricao varchar(10), tipo varchar(1))
    RETURNS TABLE (saldoR integer, limiteR integer) AS $$

    DECLARE saldoNovo integer;
    clienteASerAtualizado cliente%rowtype;
    clienteR cliente%rowtype;

BEGIN
    SELECT * FROM cliente INTO clienteASerAtualizado WHERE id = cliente_id FOR UPDATE;

    IF not found THEN
        RAISE EXCEPTION 'cliente nao encontrado';
    END IF;

    IF tipo = 'd' THEN
        IF clienteASerAtualizado.saldo + clienteASerAtualizado.limite >= valor THEN
            saldoNovo := clienteASerAtualizado.saldo - valor;
        ELSE
            RAISE EXCEPTION 'nao possui limite';
        END IF;
    ELSE
        saldoNovo := clienteASerAtualizado.saldo + valor;
    END IF;

    UPDATE cliente SET saldo = saldoNovo WHERE id = cliente_id RETURNING * INTO clienteR;

    INSERT INTO transacao (cliente_id, valor, tipo, descricao) VALUES (cliente_id, valor, tipo, descricao);

    RETURN QUERY SELECT clienteR.saldo, clienteR.limite;
END;
$$ LANGUAGE plpgsql;