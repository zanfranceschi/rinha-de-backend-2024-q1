CREATE TABLE clients (
	id SERIAL PRIMARY KEY,
	"name" VARCHAR(50) NOT NULL,
	"limit" INTEGER NOT NULL,
	balance INTEGER NOT NULL
);

CREATE TABLE transactions (
	id SERIAL PRIMARY KEY,
	client_id INTEGER NOT NULL,
	"value" INTEGER NOT NULL,
	"type" CHAR(1) NOT NULL,
	"description" VARCHAR(10) NOT NULL,
	date_added TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_client_id ON transactions (client_id);


DO $$
BEGIN
	INSERT INTO clients ("name", "limit", balance)
	VALUES
		('o barato sai caro', 1000 * 100, 0),
		('zan corp ltda', 800 * 100, 0),
		('les cruders', 10000 * 100, 0),
		('padaria joia de cocaia', 100000 * 100, 0),
		('kid mais', 5000 * 100, 0);
END;
$$;