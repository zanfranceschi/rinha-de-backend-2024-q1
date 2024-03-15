DO $$ BEGIN
 CREATE TYPE "transaction_type" AS ENUM('c', 'd');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "clients" (
	"id" serial PRIMARY KEY NOT NULL,
	"balance" integer DEFAULT 0 NOT NULL,
	"limit" integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "transactions" (
	"id" serial PRIMARY KEY NOT NULL,
	"client_id" integer NOT NULL,
	"amount" integer NOT NULL,
	"transaction_type" "transaction_type" NOT NULL,
	"description" varchar(10) NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "transactions" ADD CONSTRAINT "transactions_client_id_clients_id_fk" FOREIGN KEY ("client_id") REFERENCES "clients"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    INSERT INTO clients("limit")
    VALUES
        (1000 * 100),
        (800 * 100),
        (10000 * 100),
        (100000 * 100),
        (5000 * 100);
END $$;