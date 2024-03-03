CREATE TABLE consumers (
        id SERIAL PRIMARY KEY,
        bound INTEGER NOT NULL,
        balance INTEGER NOT NULL
);

CREATE TABLE transactions (
        id SERIAL PRIMARY KEY,
        consumer_id INTEGER NOT NULL,
        type VARCHAR(1) NOT NULL,
        value INTEGER NOT NULL,
        description VARCHAR(10) NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION create_transaction_and_update_consumer(
    fn_consumer_id integer,
    fn_type text,
    fn_value integer,
    fn_description text
) RETURNS table (fn_balance int, fn_limit int)
LANGUAGE plpgsql
AS $$
DECLARE
    v_balance INT;
    v_bound INT;
BEGIN
    SELECT c.balance, c.bound into v_balance, v_bound FROM consumers c  WHERE id = fn_consumer_id FOR UPDATE;

    IF fn_type = 'd' AND v_balance - fn_value < -v_bound THEN
            RAISE EXCEPTION 'Limite excedido';
    END IF;

    INSERT INTO transactions (consumer_id, "type", value, description, created_at)
    VALUES (fn_consumer_id, fn_type, fn_value, fn_description, now());

    UPDATE consumers
    SET balance = CASE WHEN fn_type= 'd' THEN v_balance - fn_value ELSE v_balance + fn_value END
    WHERE id = fn_consumer_id;

    RETURN QUERY select c.balance, c.bound FROM consumers c  WHERE id = fn_consumer_id;
END;
$$;

DO $$
BEGIN
INSERT INTO consumers (bound, balance)
VALUES
    (1000 * 100, 0),
    (800 * 100, 0),
    (10000 * 100, 0),
    (100000 * 100, 0),
    (5000 * 100, 0);
END; $$