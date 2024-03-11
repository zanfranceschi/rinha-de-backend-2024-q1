-- insert transaction into ledger using an optimistic lock approach
CREATE OR REPLACE FUNCTION create_transaction(
    in_client_id INTEGER,
    -- if in_type == 'd', in_value must be negative. if in_type == 'c', in_value must be positive
    in_value INTEGER,
    in_type CHAR,
    in_description VARCHAR(10),
    OUT out_limit INTEGER,
    OUT out_balance INTEGER,
    OUT out_updated_row_count INTEGER
)
RETURNS RECORD
LANGUAGE 'plpgsql'
AS $$
DECLARE
    pending BOOLEAN := TRUE;
    t_count INTEGER;
BEGIN
    out_updated_row_count := 0;

    WHILE pending LOOP
        SELECT client_limit, client_balance + in_value, client_transaction_count INTO out_limit, out_balance, t_count
        FROM ledger
        WHERE client_id = in_client_id
        ORDER BY client_transaction_count DESC
        LIMIT 1;

        IF out_balance < out_limit THEN
            RETURN;
        END IF;

        BEGIN
            INSERT INTO ledger (client_id, client_limit, client_balance, transaction_value, transaction_type, transaction_description, client_transaction_count)
            VALUES (in_client_id, out_limit, out_balance, in_value, in_type, in_description, t_count + 1);

            GET DIAGNOSTICS out_updated_row_count = ROW_COUNT;
            pending := FALSE;
        EXCEPTION WHEN unique_violation THEN
        END;
    END LOOP;
END;
$$;
