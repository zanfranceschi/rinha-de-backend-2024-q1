DO
$$
    BEGIN

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

        create table public.users
        (
            id      bigserial primary key,
            name    varchar(255),
            "limit" bigint,
            balance bigint
        );

        create table public.transaction
        (
            id          bigserial primary key,
            created_at  timestamp,
            value       bigint,
            description varchar(10),
            user_id     bigint
        );

-- Inserção de valores iniciais na tabela clientes
        INSERT INTO users (id, balance, "limit") VALUES (1, 0, -100000);
        INSERT INTO users (id, balance, "limit") VALUES (2, 0, -80000);
        INSERT INTO users (id, balance, "limit") VALUES (3, 0, -1000000);
        INSERT INTO users (id, balance, "limit") VALUES (4, 0, -10000000);
        INSERT INTO users (id, balance, "limit") VALUES (5, 0, -500000);

    END
$$;

CREATE OR REPLACE FUNCTION createtransaction(
    IN idUser integer,
    IN value integer,
    IN description varchar(10)
) RETURNS RECORD AS
$$
DECLARE
    userfound users%rowtype;
    ret       RECORD;
BEGIN
    SELECT *
    FROM users
    INTO userfound
        WHERE
    id = idUser;

    IF not found THEN
        --raise notice'Id user % not found.', idUser;
        select -1 into ret;
        RETURN ret;
    END IF;

    --raise notice'transaction by user %.', idUser;
    INSERT INTO transaction (value, description, created_at, user_id)
    VALUES (value, description, now() at time zone 'utc', idUser);
    UPDATE users
    SET balance = balance + value
    WHERE id = idUser
      AND (value > 0 OR balance + value >= "limit")
    RETURNING balance, "limit"
        INTO ret;
    raise notice 'Ret: %', ret;
    IF ret."limit" is NULL THEN
        --raise notice'Id  user % not found.', idUser;
        select -2 into ret;
    END IF;
    RETURN ret;
END;
$$ LANGUAGE plpgsql;

