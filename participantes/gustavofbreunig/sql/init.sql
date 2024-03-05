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

CREATE UNLOGGED TABLE clientes (
        id SERIAL PRIMARY KEY,
        limite INTEGER NOT NULL,
        saldo INTEGER NOT NULL
);

CREATE UNLOGGED TABLE transacoes (
        id SERIAL PRIMARY KEY,
        cliente_id INTEGER NOT NULL,
        valor INTEGER NOT NULL,
        tipo CHAR(1) NOT NULL,
        descricao VARCHAR(10) NOT NULL,
        realizada_em TIMESTAMP WITH TIME ZONE NOT NULL,
        CONSTRAINT fk_clientes_transacoes_id
                FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

DO $$
BEGIN
        INSERT INTO clientes (limite, saldo)
        VALUES
                (100000, 0),
                (80000, 0),
                (1000000, 0),
                (10000000, 0),
                (500000, 0);

END;
$$;
