SET timezone = 'America/Sao_Paulo';
CREATE SCHEMA IF NOT EXISTS rinha;

CREATE TABLE rinha.users
(
    id              SERIAL PRIMARY KEY,
    limit_in_cents  INTEGER NOT NULL,
    initial_balance INTEGER NOT NULL DEFAULT 0
);

INSERT INTO rinha.users (id, limit_in_cents, initial_balance)
VALUES (DEFAULT, 1000 * 100, 0),
       (DEFAULT, 800 * 100, 0),
       (DEFAULT, 10000 * 100, 0),
       (DEFAULT, 100000 * 100, 0),
       (DEFAULT, 5000 * 100, 0);

CREATE UNLOGGED TABLE rinha.history
(
    id          SERIAL PRIMARY KEY,
    user_id     SMALLINT    NOT NULL,
    value       INTEGER     NOT NULL,
    type        CHAR(1)     NOT NULL,
    description VARCHAR(10) NOT NULL,
    do_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE
    rinha.history
    SET
        (autovacuum_enabled = false);

CREATE INDEX idx_history ON rinha.history (user_id);


CREATE OR REPLACE FUNCTION rinha.credit(
    user_id_tx SMALLINT,
    value_tx INT,
    description_tx VARCHAR(10))
    RETURNS TABLE
            (
                new_balance   INT,
                success       BOOL,
                current_limit INT
            )
    LANGUAGE plpgsql
AS
$$
BEGIN
    PERFORM pg_advisory_xact_lock(user_id_tx);

    INSERT INTO rinha.history VALUES (DEFAULT, user_id_tx, value_tx, 'c', description_tx);

    RETURN QUERY
        UPDATE rinha.users
            SET initial_balance = initial_balance + value_tx
            WHERE id = user_id_tx
            RETURNING initial_balance, TRUE, limit_in_cents;
END;
$$;

CREATE OR REPLACE FUNCTION rinha.debit(
    user_id_tx SMALLINT,
    value_tx INT,
    description_tx VARCHAR(10))
    RETURNS TABLE
            (
                new_balance   INT,
                success       BOOL,
                current_limit INT
            )
    LANGUAGE plpgsql
AS
$$
DECLARE
    current_balance     int;
    current_limit_value int;
BEGIN
    PERFORM pg_advisory_xact_lock(user_id_tx);

    SELECT limit_in_cents,
           initial_balance
    INTO
        current_limit_value,
        current_balance
    FROM rinha.users
    WHERE id = user_id_tx;

    IF current_balance - value_tx >= current_limit_value * -1 THEN
        INSERT INTO rinha.history VALUES (DEFAULT, user_id_tx, value_tx, 'd', description_tx);

        RETURN QUERY
            UPDATE rinha.users
                SET initial_balance = initial_balance - value_tx
                WHERE id = user_id_tx
                RETURNING initial_balance, TRUE, limit_in_cents;

    ELSE
        RETURN QUERY SELECT current_balance, FALSE, current_limit_value;
    END IF;
END;
$$;

