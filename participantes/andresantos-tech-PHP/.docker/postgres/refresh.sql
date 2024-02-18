DO $$
BEGIN

UPDATE accounts SET current_balance = 0 WHERE id >= 1;
TRUNCATE TABLE transactions;

END;
$$;