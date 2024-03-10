CREATE UNLOGGED TABLE IF NOT EXISTS "client" (
	"id" integer NOT NULL,
	"limit" integer NOT NULL,
	"balance" integer NOT NULL
);

CREATE UNLOGGED TABLE IF NOT EXISTS "transactions" (
	"id" serial NOT NULL,
	"amount" integer NOT NULL,
	"type" smallint NOT NULL,
	"description" text NOT NULL,
	"created_at" timestamp DEFAULT now(),
	"client_id" integer NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_client_id ON "transactions" (client_id);

CREATE EXTENSION IF NOT EXISTS pg_prewarm;

SELECT pg_prewarm('client');

SELECT pg_prewarm('transactions');


INSERT INTO public.client (id,"limit",balance) VALUES
	 (1,100000,0),
	 (2,80000,0),
	 (3,1000000,0),
	 (4,10000000,0),
	 (5,500000,0);


/*
FROM library/postgres
COPY init.sql /docker-entrypoint-initdb.d/
*/