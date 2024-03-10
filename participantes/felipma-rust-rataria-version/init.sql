CREATE UNLOGGED TABLE IF NOT EXISTS "clients" (
    "id" SERIAL PRIMARY KEY NOT NULL,
    "limit" INTEGER NOT NULL,
    "balance" INTEGER NOT NULL
);

CREATE UNLOGGED TABLE IF NOT EXISTS "transactions" (
    "id" SERIAL PRIMARY KEY NOT NULL,
    "value" INTEGER NOT NULL,
    "type" CHAR(1) NOT NULL,
    "description" VARCHAR(10) NOT NULL,
    "date" TIMESTAMP NOT NULL DEFAULT NOW(),
    "client_id" INTEGER NOT NULL,
    FOREIGN KEY ("client_id") REFERENCES "clients" ("id") ON DELETE CASCADE
);

INSERT INTO "clients" ("limit", "balance")
VALUES (100000, 0), (80000, 0), (1000000, 0), (10000000, 0), (500000, 0);
