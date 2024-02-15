CREATE TABLE IF NOT EXISTS accounts (
    id SERIAL PRIMARY KEY,
    account_limit INT,
    balance INT,
    version INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS transactions (
    id SERIAL PRIMARY KEY,
    amount INT,
    type CHAR(1),
    description VARCHAR(10),
    created_at TIMESTAMP,
    account_id INT
);

DO $$
BEGIN
  IF NOT EXISTS (SELECT * FROM accounts WHERE id BETWEEN 1 AND 5) THEN
    INSERT INTO accounts (account_limit, balance) 
    VALUES 
    (100000, 0),
    (80000, 0),
    (1000000, 0),
    (10000000, 0),
    (500000, 0);
  END IF;
END;
$$;