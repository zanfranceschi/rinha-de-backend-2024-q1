DO $$ BEGIN
 CREATE TYPE "tipo_transacao" AS ENUM('c', 'd');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "clientes" (
	"id" serial PRIMARY KEY NOT NULL,
	"limite" integer DEFAULT 0 NOT NULL,
	"saldo" integer DEFAULT 0 NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "transacoes" (
	"id" serial PRIMARY KEY NOT NULL,
	"id_cliente" integer,
	"valor" integer DEFAULT 0 NOT NULL,
	"tipo_transacao" "tipo_transacao",
	"descricao" text,
	"realizada_em" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "id_cliente_idx" ON "transacoes" ("id_cliente");--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "transacoes" ADD CONSTRAINT "transacoes_id_cliente_clientes_id_fk" FOREIGN KEY ("id_cliente") REFERENCES "clientes"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
