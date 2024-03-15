DROP FUNCTION IF EXISTS "create_new_transaction" CASCADE;

CREATE OR REPLACE FUNCTION create_new_transaction (
  IN new_transaction_client_id INT,
  IN new_transaction_type transaction_type,
  IN new_transaction_description VARCHAR(10),
  IN new_transaction_value BIGINT
) RETURNS TABLE ("balance" BIGINT, "limit" BIGINT) AS $$ 
DECLARE
    client_previous_transaction_id BIGINT;
    client_current_balance BIGINT;
    client_user_limit BIGINT;
    client_new_balance BIGINT;
BEGIN
    SELECT user_limit.limit INTO client_user_limit FROM user_limit WHERE user_limit.user_id = new_transaction_client_id FOR UPDATE;

    IF NOT FOUND THEN
    RETURN;
    END IF;

    SELECT transaction.id, transaction.current_balance INTO client_previous_transaction_id, client_current_balance FROM transaction WHERE transaction.user_id = new_transaction_client_id ORDER BY transaction.id DESC LIMIT 1;

    IF NOT FOUND THEN
    client_current_balance := 0;
    client_previous_transaction_id := null;
    END IF;

    IF new_transaction_type = 'd' 
    THEN client_new_balance := client_current_balance - new_transaction_value;
      IF client_new_balance < client_user_limit * -1 
      THEN RAISE EXCEPTION 'insufficient balance for transaction';
      END IF;
    ELSE client_new_balance := client_current_balance + new_transaction_value;
    END IF;

    INSERT INTO
      transaction (type, description, value, user_id, current_balance, previous_transaction_id)
    VALUES (new_transaction_type, new_transaction_description, new_transaction_value, new_transaction_client_id, client_new_balance, client_previous_transaction_id);

    RETURN QUERY 
    SELECT client_new_balance, client_user_limit;
END;
$$ LANGUAGE plpgsql;