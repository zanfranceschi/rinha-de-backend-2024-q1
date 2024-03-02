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

CREATE UNLOGGED TABLE IF NOT EXISTS client (
    id SERIAL PRIMARY KEY,
    credit BIGINT NOT NULL,
    balance BIGINT NOT NULL DEFAULT 0
);


CREATE UNLOGGED TABLE IF NOT EXISTS client_transaction (
    id SERIAL PRIMARY KEY,
    client_id INT NOT NULL,
    amount BIGINT NOT NULL,
    description TEXT NULL,
    transaction_type TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT client_id_fk FOREIGN KEY (client_id) REFERENCES client (id)
);

create index client_transaction_client_id_idx on client_transaction (client_id);

CREATE OR REPLACE FUNCTION validate_transaction(
    IN clientId BIGINT,
    IN valor BIGINT,
    IN descricao TEXT,
    IN tipo TEXT
) RETURNS RECORD AS $$
    DECLARE
        ret RECORD;
        clientencontrado client%rowtype;
    BEGIN
        SELECT * INTO clientencontrado FROM client WHERE id = clientId FOR UPDATE;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Client not found';
        END IF;

        IF tipo = 'd' AND clientencontrado.credit + (clientencontrado.balance - valor) < 0
        THEN
            RAISE EXCEPTION 'Insufficient funds';
        END IF;

        INSERT INTO client_transaction (client_id, amount, description, transaction_type)
        VALUES (clientId, valor, descricao, tipo);

        UPDATE client SET balance =
            CASE
                WHEN tipo = 'c' THEN balance + valor
                WHEN tipo = 'd' THEN balance - valor
            END
            WHERE id = clientId
            RETURNING credit, balance INTO ret;
        RETURN ret;
    END;
$$ LANGUAGE plpgsql;


DO $$
BEGIN
    INSERT INTO client (credit)
    VALUES
        (1000 * 100),
        (800 * 100),
        (10000 * 100),
        (100000 * 100),
        (5000 * 100);
END; $$