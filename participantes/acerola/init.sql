--

CREATE TABLE customers(
  id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  max_limit INTEGER NOT NULL,
  balance INTEGER CHECK (balance >= -max_limit) NOT NULL
);

CREATE TABLE transactions(
  id SERIAL PRIMARY KEY,
  value INTEGER NOT NULL,
  customer_id INTEGER REFERENCES customers(id),
  type VARCHAR(1) CHECK (type IN ('c', 'd')) NOT NULL,
  description VARCHAR(10) NOT NULL,
  created_at TIMESTAMP DEFAULT now() NOT NULL
);

DO $$
BEGIN
  INSERT INTO customers (name, max_limit, balance)
  VALUES
    ('rubick', 1000 * 100, 0),
    ('zeus', 800 * 100, 0),
    ('killua', 10000 * 100, 0),
    ('freeza', 100000 * 100, 0),
    ('gohan', 5000 * 100, 0);
END; $$
