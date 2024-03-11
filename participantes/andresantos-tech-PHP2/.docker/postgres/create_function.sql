CREATE OR REPLACE FUNCTION createtransaction(
    IN account_id integer,
    IN valor integer,
    IN tipo char(1),
    IN descricao varchar(10)
) RETURNS RECORD AS $$

DECLARE
    account accounts%ROWTYPE;
    ret RECORD;
    valorInsert integer;
BEGIN
    SELECT * FROM accounts WHERE id = account_id INTO account;

    IF not found THEN
        SELECT -1, 0, 0 INTO ret;
        RETURN ret;
    END IF;

    SELECT valor INTO valorInsert;

    IF tipo = 'd' THEN
        valorInsert = -valorInsert;
    END IF;

    UPDATE accounts
    SET current_balance = accounts.current_balance + valorInsert
    WHERE id = account_id AND (valorInsert > 0 OR accounts.limit_amount + accounts.current_balance >= valor)
        RETURNING 1, limit_amount, current_balance INTO ret;

    IF ret.limit_amount is NULL THEN
        SELECT -2, 0, 0 INTO ret;
        RETURN ret;
    END IF;

    INSERT INTO transactions (account_id, amount, transaction_type, description)
    VALUES (account_id, valor, tipo, descricao);

    RETURN ret;
END;$$ LANGUAGE plpgsql;