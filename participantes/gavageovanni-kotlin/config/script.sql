DO
$$
    BEGIN
--         SET statement_timeout = 0;
--         SET lock_timeout = 0;
--         SET idle_in_transaction_session_timeout = 0;
--         SET client_encoding = 'UTF8';
--         SET standard_conforming_strings = on;
--         SET check_function_bodies = false;
--         SET xmloption = content;
--         SET client_min_messages = warning;
--         SET row_security = off;
--
--         SET default_tablespace = '';
--
--         SET default_table_access_method = heap;

        create unlogged table public.users
        (
            id      serial primary key,
            account_limit  integer not null,
            balance integer default 0
        );

        create unlogged table public.transaction
        (
            created_at  timestamp not null,
            value       integer not null,
            description varchar(10) not null,
            user_id     integer not null,
            type        char(1) not null
        );

    create index transaction_user_idx ON transaction USING btree (user_id, created_at);

-- initial data
        INSERT INTO users (id, balance, account_limit) VALUES (1, 0, 100000);
        INSERT INTO users (id, balance, account_limit) VALUES (2, 0, 80000);
        INSERT INTO users (id, balance, account_limit) VALUES (3, 0, 1000000);
        INSERT INTO users (id, balance, account_limit) VALUES (4, 0, 10000000);
        INSERT INTO users (id, balance, account_limit) VALUES (5, 0, 500000);

    END
$$;