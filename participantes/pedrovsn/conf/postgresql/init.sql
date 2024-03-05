DROP TABLE IF EXISTS customer;
CREATE TABLE customer (
    id SERIAL PRIMARY KEY,
    name VARCHAR(32) NOT NULL,
    credit_limit INTEGER NOT NULL,
    balance INTEGER NOT NULL
);

DROP TABLE IF EXISTS transaction;
CREATE TABLE transaction (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    amount INTEGER NOT NULL,
    type CHAR(1) NOT NULL,
    description VARCHAR(10),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_customer_id_transaction
        FOREIGN KEY (customer_id) REFERENCES customer(id)
);

DO $$
BEGIN
	INSERT INTO customer (name, credit_limit, balance)
	VALUES
		('o barato sai caro', 1000 * 100, 0),
		('zan corp ltda', 800 * 100, 0),
		('les cruders', 10000 * 100, 0),
		('padaria joia de cocaia', 100000 * 100, 0),
		('kid mais', 5000 * 100, 0);
END;
$$;