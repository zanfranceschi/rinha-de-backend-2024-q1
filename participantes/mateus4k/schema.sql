CREATE TABLE accounts (
	id SERIAL PRIMARY KEY,
	lim INTEGER NOT NULL,
	balance INTEGER NOT NULL
);

CREATE TABLE transactions (
	id SERIAL PRIMARY KEY,
	account_id INTEGER NOT NULL,
	amount INTEGER NOT NULL,
	type CHAR(1) NOT NULL,
	description VARCHAR(10) NOT NULL,
	date TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE PROCEDURE insert_transaction(p_account_id INTEGER, p_amount INTEGER, p_type TEXT, p_description TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE accounts SET balance = p_amount WHERE id = p_account_id;
  COMMIT;
  INSERT INTO transactions (account_id, amount, type, description) VALUES (p_account_id, p_amount, p_type, p_description);
END;
$$