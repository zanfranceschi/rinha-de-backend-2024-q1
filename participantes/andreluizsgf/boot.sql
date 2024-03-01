-- Create transactions table
CREATE UNLOGGED TABLE transaction (
  customer_id INTEGER NOT NULL,
  amount INTEGER NOT NULL,
  type CHAR(1) NOT NULL,
  description TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create customer table
CREATE UNLOGGED TABLE customer (
  id INTEGER NOT NULL,
  balance BIGINT NOT NULL,
  credit INTEGER NOT NULL
);

-- Create default customer balance
INSERT INTO
  "customer" ("id", "balance", "credit")
VALUES
  (1, 0, 100000);

INSERT INTO
  "customer" ("id", "balance", "credit")
VALUES
  (2, 0, 80000);

INSERT INTO
  "customer" ("id", "balance", "credit")
VALUES
  (3, 0, 1000000);

INSERT INTO
  "customer" ("id", "balance", "credit")
VALUES
  (4, 0, 10000000);

INSERT INTO
  "customer" ("id", "balance", "credit")
VALUES
  (5, 0, 500000);

-- create indexes 
CREATE INDEX idx_transaction_createdat_1 ON transaction (customer_id, created_at DESC) WHERE customer_id = 1;
CREATE INDEX idx_transaction_createdat_2 ON transaction (customer_id, created_at DESC) WHERE customer_id = 2;
CREATE INDEX idx_transaction_createdat_3 ON transaction (customer_id, created_at DESC) WHERE customer_id = 3;
CREATE INDEX idx_transaction_createdat_4 ON transaction (customer_id, created_at DESC) WHERE customer_id = 4;
CREATE INDEX idx_transaction_createdat_5 ON transaction (customer_id, created_at DESC) WHERE customer_id = 5;

-- Create reconcile balance trigger
CREATE
OR REPLACE FUNCTION reconcile_customer_balance () RETURNS TRIGGER LANGUAGE PLPGSQL AS $$ DECLARE cbalance INT; ccredit INT;

BEGIN
  SELECT balance, credit FROM customer c WHERE id = NEW.customer_id INTO cbalance, ccredit;

  IF NEW.type = 'd' THEN
    NEW.amount = NEW.amount * -1;
  END IF;

  IF cbalance+NEW.amount+ccredit < 0 THEN
    RAISE EXCEPTION 'no credit';
  END IF;

  UPDATE customer SET balance = balance + NEW.amount WHERE id = NEW.customer_id;

  RETURN NEW;

END;

$$;

CREATE TRIGGER reconcile_customer_balance
AFTER
INSERT
  ON transaction FOR EACH ROW EXECUTE PROCEDURE reconcile_customer_balance();