
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS transactions (
	transaction_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	customer_id INTEGER NOT NULL,
	value INTEGER NOT NULL,
	type CHAR(1) NOT NULL,
	description VARCHAR(10) NOT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS balance (
	balance_id SERIAL PRIMARY KEY,
	customer_id INTEGER NOT NULL,
	name VARCHAR(50) NOT null,
	value INTEGER NOT NULL,
  	credit INTEGER NOT NULL
);

CREATE OR REPLACE FUNCTION update_balance()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.type = 'c' THEN
        UPDATE balance SET value = value + NEW.value WHERE customer_id = NEW.customer_id;
    ELSIF NEW.type = 'd' THEN
        IF (SELECT value - NEW.value FROM balance WHERE customer_id = NEW.customer_id) < (SELECT credit * -1 FROM balance WHERE customer_id = NEW.customer_id) THEN
            RAISE EXCEPTION 'Saldo insuficiente para esta transação!';
        ELSE
            UPDATE balance SET value = value - NEW.value WHERE customer_id = NEW.customer_id;
        END IF;
    END IF;
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER transacao_trigger
AFTER INSERT
ON transactions
FOR EACH ROW
EXECUTE FUNCTION update_balance();

DO $$
BEGIN
	INSERT INTO balance (customer_id, name, credit, value)
	VALUES
		(1, 'o barato sai caro', 1000 * 100, 0),
		(2, 'zan corp ltda', 800 * 100, 0),
		(3, 'les cruders', 10000 * 100, 0),
		(4, 'padaria joia de cocaia', 100000 * 100, 0),
		(5, 'kid mais', 5000 * 100, 0);
END;
$$;

