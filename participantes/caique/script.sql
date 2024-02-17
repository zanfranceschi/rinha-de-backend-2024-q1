\connect "rinha";

CREATE TABLE IF NOT EXISTS "clients" (
    "client_id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "balance" INTEGER NOT NULL DEFAULT 0,
    "limit" INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS "transactions" (
    "id" SERIAL PRIMARY KEY,
    "client_id" INTEGER NOT NULL,
    "value" INTEGER NOT NULL,
    "type" VARCHAR(1) NOT NULL,
    "description" TEXT NOT NULL,
    "date" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ("client_id") REFERENCES "clients" ("client_id")
);

CREATE INDEX IF NOT EXISTS "client_id_t" ON "transactions" ("client_id");
CREATE INDEX IF NOT EXISTS "client_id_c" ON "clients" ("client_id");

INSERT INTO "clients" ("client_id", "name", "limit")
VALUES (1, 'John Doe', 100000),
       (2, 'Jane Doe', 80000),
       (3, 'Alice', 1000000),
       (4, 'Bob', 10000000),
       (5, 'Charlie', 500000)
ON CONFLICT("client_id") DO NOTHING;
