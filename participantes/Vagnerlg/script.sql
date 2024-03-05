DROP TABLE IF EXISTS "balance";
CREATE TABLE "public"."balance" (
    "id" integer NOT NULL,
    "_limit" integer,
    "total" integer NOT NULL,
    CONSTRAINT "balance_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

INSERT INTO "balance" ("id", "_limit", "total") VALUES
(1,	100000,	0),
(2,	80000,	0),
(3,	1000000,	0),
(4,	10000000,	0),
(5,	500000,	0);

DROP TABLE IF EXISTS "transaction";
CREATE TABLE "public"."transaction" (
    "id" integer NOT NULL,
    "created_at" timestamp(6),
    "description" character varying(255),
    "type" smallint,
    "user_id" integer NOT NULL,
    "value" integer NOT NULL,
    CONSTRAINT "transaction_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE SEQUENCE transaction_seq START 1;
CREATE INDEX user_idx ON transaction (user_id);
