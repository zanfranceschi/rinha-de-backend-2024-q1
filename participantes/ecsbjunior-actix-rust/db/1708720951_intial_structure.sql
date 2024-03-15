CREATE TABLE IF NOT EXISTS "clients" (
  "id"      INT     PRIMARY KEY,
  "limit"   INTEGER NOT NULL,
  "balance" INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS "transactions" (
  "id"          SERIAL      PRIMARY KEY,
  "kind"        CHAR(1)     NOT NULL,
  "amount"      INTEGER     NOT NULL,
  "description" VARCHAR(10) NOT NULL,
  "client_id"   INTEGER     NOT NULL,
  "created_at"  TIMESTAMP   NOT NULL,

  CONSTRAINT "fk_transactions_clients" FOREIGN KEY ("client_id") REFERENCES "clients" ("id")
);

CREATE INDEX "idx_transactions_client_id" ON "transactions" ("client_id");

INSERT INTO "clients" ("id", "limit") VALUES (1, 100000);
INSERT INTO "clients" ("id", "limit") VALUES (2, 80000);
INSERT INTO "clients" ("id", "limit") VALUES (3, 1000000);
INSERT INTO "clients" ("id", "limit") VALUES (4, 10000000);
INSERT INTO "clients" ("id", "limit") VALUES (5, 500000);
