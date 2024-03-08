CREATE TABLE customers (
	id SERIAL PRIMARY KEY,
	max_limit INTEGER NOT NULL,
	balance INTEGER NOT NULL
);

CREATE TABLE transactions(
  id SERIAL PRIMARY KEY,
  value INTEGER NOT NULL,
  customer_id INTEGER REFERENCES customers(id),
  type VARCHAR(1) CHECK (type IN ('c', 'd')) NOT NULL,
  description VARCHAR(10) NOT NULL,
  inserted_at TIMESTAMP,
  updated_at TIMESTAMP
);

DO $$
BEGIN
	INSERT INTO customers (max_limit, balance)
	VALUES
		(1000 * 100, 0),
		(800 * 100, 0),
		(10000 * 100, 0),
		(100000 * 100, 0),
		(5000 * 100, 0);
END;
$$;