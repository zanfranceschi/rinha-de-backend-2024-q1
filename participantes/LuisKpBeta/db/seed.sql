CREATE UNLOGGED TABLE IF NOT EXISTS customers (
    id serial PRIMARY KEY,
    balance integer NOT NULL DEFAULT 0,
    account_limit integer NOT NULL DEFAULT 0
);

CREATE UNLOGGED TABLE  IF NOT EXISTS transactions (
  id serial PRIMARY KEY,
  value integer NOT NULL,
  description varchar(11) NOT NULL, 
  type varchar(1) NOT NULL,
  customer_id int NOT NULL,
  operation_date timestamptz NOT NULL, 
  FOREIGN KEY (customer_id) REFERENCES customers (id)
);

DO $$
BEGIN
  INSERT INTO customers (account_limit)
  VALUES
    (1000 * 100),
    (800 * 100),
    (10000 * 100),
    (100000 * 100),
    (5000 * 100);
END; $$

