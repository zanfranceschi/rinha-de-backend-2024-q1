CREATE TABLE accounts (
  id int,
  balance bigint NOT NULL,
  available_limit bigint NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE entries (
  id uuid,
  account_id int NOT NULL,
  amount bigint NOT NULL,
  description varchar(10) NOT NULL,
  inserted_at timestamp with time zone NOT NULL,

  PRIMARY KEY (id)
);

CREATE INDEX idx_entries ON entries(account_id, inserted_at DESC);

CREATE TYPE transaction_result AS (
  new_balance bigint, 
  available_limit bigint
);

CREATE FUNCTION perform_transaction(_tx_id uuid, _account_id int, _amount bigint, _description text)
RETURNS transaction_result
LANGUAGE plpgsql AS $$
DECLARE
	_result transaction_result;
BEGIN
  SELECT
  	acc.balance + _amount, acc.available_limit
  INTO
  	_result.new_balance, _result.available_limit
  FROM accounts acc
  WHERE acc.id = _account_id
  FOR UPDATE;

  IF NOT FOUND THEN
  	RAISE EXCEPTION USING 
        message='Account not found',
        errcode='TRX01';
  END IF;

  IF _result.new_balance < -_result.available_limit THEN
  	RAISE EXCEPTION USING 
        message='Insufficient balance',
        errcode='TRX02';
  END IF;

  INSERT INTO entries 
    (id, account_id, amount, description, inserted_at)
  VALUES
    (_tx_id, _account_id, _amount, _description, now());

  UPDATE accounts acc
  SET balance = _result.new_balance
  WHERE acc.id = _account_id;

  RETURN _result;
END
$$;

CREATE FUNCTION lookup_statement(_account_id int)
RETURNS TABLE (balance bigint, available_limit bigint, latest_entries json)
LANGUAGE plpgsql AS $$
BEGIN
  RETURN QUERY
      WITH latest_entries AS (
        SELECT
          e.account_id,
          e.amount,
          e.description,
          e.inserted_at
        FROM entries e
        WHERE e.account_id = _account_id
        ORDER BY inserted_at DESC
        LIMIT 10
      ), le_json AS (
        SELECT
          json_agg(le) latest_entries
        FROM latest_entries le
      )
      SELECT acc.balance, acc.available_limit, le_json.latest_entries FROM le_json, accounts acc WHERE acc.id = _account_id;
END
$$;

INSERT INTO accounts 
    (id, balance, available_limit)
VALUES
    (1, 0, 1000 * 100),
    (2, 0, 800 * 100),
    (3, 0, 10000 * 100),
    (4, 0, 100000 * 100),
    (5, 0, 5000 * 100);
