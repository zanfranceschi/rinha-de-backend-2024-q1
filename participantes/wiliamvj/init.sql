-- set postgres config
SET default_table_access_method = heap;
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

CREATE UNLOGGED TABLE client (
    id integer PRIMARY KEY NOT NULL,
    balance integer NOT NULL,
    u_limit integer NOT NULL
);

CREATE UNLOGGED TABLE bank_transaction (
    id SERIAL PRIMARY KEY,
    value integer NOT NULL,
    description varchar(10) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    client_id integer NOT NULL,
    type char(1) NOT NULL,
    FOREIGN KEY (client_id) REFERENCES client (id)
);

CREATE INDEX IF NOT EXISTS idx_clients_client_id ON client (id);
CREATE INDEX IF NOT EXISTS idx_created_at ON bank_transaction (created_at DESC);

INSERT INTO client (id, balance, u_limit) VALUES (1, 0, 100000);
INSERT INTO client (id, balance, u_limit) VALUES (2, 0, 80000);
INSERT INTO client (id, balance, u_limit) VALUES (3, 0, 1000000);
INSERT INTO client (id, balance, u_limit) VALUES (4, 0, 10000000);
INSERT INTO client (id, balance, u_limit) VALUES (5, 0, 500000);

CREATE EXTENSION IF NOT EXISTS pg_prewarm;
SELECT pg_prewarm('client');
SELECT pg_prewarm('bank_transaction');

DROP TYPE IF EXISTS create_transaction_result;
CREATE TYPE create_transaction_result AS ( balance integer, u_limit integer );

CREATE OR REPLACE FUNCTION new_transaction(
    IN client_id integer,
    IN value integer,
    IN description varchar(10),
    IN type char(1)
) RETURNS create_transaction_result AS $$
DECLARE
    tr create_transaction_result;
BEGIN
    UPDATE client 
    SET balance = CASE 
        WHEN type = 'd' THEN balance - value
        ELSE balance + value
    END 
    WHERE id = client_id AND (type <> 'd' OR (balance - value) >= -u_limit) 
    RETURNING balance, u_limit INTO tr;

    IF NOT FOUND THEN
        RETURN NULL;
    ELSE
        INSERT INTO bank_transaction (value, description, created_at, client_id, type) 
        VALUES (value, description, now() AT TIME ZONE 'utc', client_id, type);
    END IF;

    RETURN tr;
END;
$$ LANGUAGE plpgsql;
