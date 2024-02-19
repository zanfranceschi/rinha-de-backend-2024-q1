-- inspired/stolen from that guy that knows alot of c# but I forgot the name
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

CREATE UNLOGGED TABLE pessoas (
    id int NOT NULL PRIMARY KEY,
    limite int NOT NULL CHECK (limite > 0),
    saldo int NOT NULL,
    CHECK (saldo > -limite)
);

CREATE UNLOGGED TABLE transacoes (
    pessoa_id int NOT NULL,
    valor int NOT NULL,
    tipo varchar(1) NOT NULL,
    descricao varchar(10) NOT NULL,
    realizada_em timestamp NOT NULL
);

CREATE INDEX idx_transacoes_pessoa_id ON transacoes (pessoa_id, realizada_em DESC);

INSERT INTO pessoas (id, limite, saldo) VALUES (1, 100000, 0);
INSERT INTO pessoas (id, limite, saldo) VALUES (2, 80000, 0);
INSERT INTO pessoas (id, limite, saldo) VALUES (3, 1000000, 0);
INSERT INTO pessoas (id, limite, saldo) VALUES (4, 10000000, 0);
INSERT INTO pessoas (id, limite, saldo) VALUES (5, 500000, 0);

CREATE OR REPLACE PROCEDURE SALVAR_TRANSACAO(
    id_pessoa int,
    tipo varchar(1),
    valor int,
    descricao varchar(10),
    INOUT resultado varchar(255)
)
LANGUAGE plpgsql
AS $$
DECLARE
    var_novo_saldo int;
    var_atual_limite int;
BEGIN
    IF tipo = 'c' THEN
        UPDATE pessoas
            SET
                saldo = saldo + valor,
                limite = limite
            WHERE id = id_pessoa
            RETURNING saldo, limite
                INTO var_novo_saldo, var_atual_limite;
    ELSE
        UPDATE pessoas
            SET
                saldo = saldo - valor,
                limite = limite
            WHERE id = id_pessoa
            RETURNING saldo, limite
                INTO var_novo_saldo, var_atual_limite;
    END IF;

    IF NOT FOUND THEN
        resultado = '-1';
        RETURN;
    ELSE
        INSERT INTO transacoes (pessoa_id, valor, tipo, descricao, realizada_em)
            VALUES (id_pessoa, valor, tipo, descricao, CURRENT_TIMESTAMP);

        COMMIT;
        resultado = CONCAT(var_novo_saldo::varchar, ':', var_atual_limite::varchar);
    END IF;
END;
$$;
