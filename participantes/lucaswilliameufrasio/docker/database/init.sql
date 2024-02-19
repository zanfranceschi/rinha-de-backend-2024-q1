DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    id INTEGER PRIMARY KEY NOT NULL,
    "name" VARCHAR(80) NOT NULL,
    balance INTEGER DEFAULT 0 NOT NULL,
    "limit" INTEGER NOT NULL
);

CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    description VARCHAR(10) NOT NULL,
  	type CHAR(1) NOT NULL,
    value INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL,
    customer_id INTEGER NOT NULL
);

CREATE INDEX IF NOT EXISTS "transactions_customer_id_idx" ON "transactions"("customer_id" ASC);

ALTER TABLE "transactions" ADD CONSTRAINT "transactions_customer_id_idx" FOREIGN KEY ("customer_id") REFERENCES "customers"("id");

DO $$
BEGIN
  INSERT INTO customers (id, name, "limit")
  VALUES
    (1, 'o barato sai caro', 1000 * 100),
    (2, 'zan corp ltda', 800 * 100),
    (3, 'les cruders', 10000 * 100),
    (4, 'padaria joia de cocaia', 100000 * 100),
    (5, 'kid mais', 5000 * 100);
END; $$;

DROP FUNCTION IF EXISTS prevent_negative_balance;
CREATE FUNCTION
  prevent_negative_balance () RETURNS TRIGGER AS $$
DECLARE
    updated_balance INTEGER;
    the_limit INTEGER;
BEGIN
		IF NEW.type = 'c' THEN
    	RETURN NEW;
    END IF;
    
    SELECT
	  	customers.balance - NEW.value,
  		-customers.limit
    INTO updated_balance, the_limit
		FROM
  		customers
		WHERE
  		customers.id = NEW.customer_id;
 
    IF updated_balance < the_limit THEN
        RAISE EXCEPTION 'The transaction cannot exceed the bounds of the balance.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER
  check_balance BEFORE INSERT ON transactions FOR EACH ROW
EXECUTE
  FUNCTION prevent_negative_balance();
