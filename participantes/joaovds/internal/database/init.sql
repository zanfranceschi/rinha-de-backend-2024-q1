CREATE UNLOGGED TABLE accounts (
  id SERIAL PRIMARY KEY,
  "limit" INTEGER NOT NULL,
  balance INTEGER NOT NULL DEFAULT 0
);

CREATE UNLOGGED TABLE transactions (
  id SERIAL PRIMARY KEY,
  value INTEGER NOT NULL,
  type_transaction char(1) NOT NULL CHECK (type_transaction IN ('c', 'd')),
  description VARCHAR(10) NOT NULL,
  realized_at timestamp NOT NULL DEFAULT now(),
  account_id INTEGER NOT NULL,
  FOREIGN KEY (account_id) REFERENCES accounts(id)
);

CREATE INDEX idx_realized_at ON transactions (realized_at);

DO $$
  BEGIN
    IF NOT EXISTS (SELECT * FROM accounts WHERE id BETWEEN 1 AND 5) THEN
      INSERT INTO accounts ("limit") 
      VALUES 
      (100000),
      (80000),
      (1000000),
      (10000000),
      (500000);
    END IF;
  END;
  $$;

CREATE OR REPLACE FUNCTION insert_transaction_and_update_client_balance(
  IN value INTEGER,
  IN type_transaction char(1),
  IN description VARCHAR(10),
  IN account_id INTEGER
) RETURNS JSON AS $$
DECLARE
  account_limit INTEGER;
  new_balance INTEGER;
BEGIN
  account_limit := (SELECT "limit" FROM accounts WHERE id = account_id);

  IF type_transaction = 'd' THEN
    new_balance := (SELECT balance FROM accounts WHERE id = account_id) - value;

    IF new_balance < -account_limit THEN
      RAISE EXCEPTION 'The transaction cannot be completed. Inconsistent balance';
    END IF;

  ELSEIF type_transaction = 'c' THEN
    new_balance := (SELECT balance FROM accounts WHERE id = account_id) + value;
  END IF;

  INSERT INTO transactions (value, type_transaction, description, account_id) VALUES (value, type_transaction, description, account_id);

  UPDATE accounts SET balance = new_balance WHERE id = account_id;

  RETURN json_build_object('limite', account_limit, 'saldo', new_balance);
END;
$$ LANGUAGE plpgsql;
