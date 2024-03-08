CREATE USER postgres SUPERUSER;

CREATE TABLE IF NOT EXISTS "clients" (
  "id" SERIAL PRIMARY KEY,
  "balance" INTEGER NOT NULL DEFAULT 0, 
  "limit" INTEGER NOT NULL,
  "created_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TYPE transactions_type AS ENUM ('c', 'd');

CREATE TABLE IF NOT EXISTS "transactions" (
	"id" SERIAL NOT NULL,
	"client_id" INTEGER NOT NULL,
	"type" transactions_type NOT NULL,
	"amount" INTEGER NOT NULL,
	"description" VARCHAR(10) NOT NULL,
	"created_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT "transactions_pk" PRIMARY KEY("id"),
	CONSTRAINT "transactions_fk_client_id"
		FOREIGN KEY("client_id") 
		REFERENCES "clients"("id")
);