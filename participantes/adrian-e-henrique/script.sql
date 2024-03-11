CREATE TABLE IF NOT EXISTS customers (
  id SERIAL PRIMARY KEY,
  "limit" integer NOT NULL,
  balance integer NOT NULL
);

CREATE TABLE IF NOT EXISTS transactions (
  id SERIAL PRIMARY KEY,
  amount integer NOT NULL,
  type VARCHAR(100) NOT NULL,
  description VARCHAR(100) NOT NULL,
  "customerId" integer NOT NULL,
  "createdAt" timestamp NOT NULL,
  FOREIGN KEY ("customerId") REFERENCES customers(id)
);

INSERT INTO customers (id, "limit", balance) VALUES
  (1, 100000, 0),
  (2, 80000, 0),
  (3, 1000000, 0),
  (4, 10000000, 0),
  (5, 500000, 0);