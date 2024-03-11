SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;

CREATE UNLOGGED TABLE client (
	"id" uuid DEFAULT gen_random_uuid(),
	"client_id" SERIAL PRIMARY KEY,
	"amount" INTEGER NOT NULL,
	"limit" INTEGER NOT NULL
);

CREATE UNLOGGED TABLE transaction (
	"id" uuid DEFAULT gen_random_uuid(),
	"transaction_id" SERIAL PRIMARY KEY,
	"value" INTEGER NOT NULL,
	"type" CHAR(1) NOT NULL,
	"description" VARCHAR(10) NOT NULL,
	"client_id" INTEGER NOT NULL,
	"created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
  CONSTRAINT "fk_client_transaction_id"
		FOREIGN KEY (client_id) REFERENCES client(client_id)
);


DO $$
BEGIN
	INSERT INTO client ("amount", "limit")
	VALUES
		(0, 1000 * 100),
		(0, 800 * 100),
		(0, 10000 * 100),
		(0, 100000 * 100),
		(0, 5000 * 100);
END;
$$;