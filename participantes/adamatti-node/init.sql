CREATE UNLOGGED TABLE IF NOT EXISTS "clients" (
	"id" integer PRIMARY KEY NOT NULL,
	"limit" integer NOT NULL,
	"balance" integer DEFAULT 0 NOT NULL
);

--> statement-breakpoint
CREATE UNLOGGED TABLE IF NOT EXISTS "transactions" (
	"id" serial PRIMARY KEY NOT NULL,
	"value" integer NOT NULL,
	"description" text NOT NULL,
	"client_id" integer NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);

--> statement-breakpoint
-- CREATE INDEX IF NOT EXISTS "client_id_idx" ON "clients" ("id");--> statement-breakpoint
-- CREATE INDEX IF NOT EXISTS "transaction_id_idx" ON "transactions" ("id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "transaction_client_id_idx" ON "transactions" ("client_id");--> statement-breakpoint

--> constraints

alter table clients add constraint current_balance_within_limit check (balance >= -"limit");

/*
DO $$ BEGIN
 ALTER TABLE "transactions" ADD CONSTRAINT "transactions_client_id_clients_id_fk" FOREIGN KEY ("client_id") REFERENCES "clients"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
*/

