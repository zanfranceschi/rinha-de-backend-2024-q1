DROP TABLE IF EXISTS "user_limit" CASCADE;

CREATE TABLE
  IF NOT EXISTS "user_limit" (
    "user_id" SERIAL NOT NULL,
    "limit" BIGINT NOT NULL
  );

CREATE UNIQUE INDEX IF NOT EXISTS "user_limit_id_key" ON "user_limit" ("user_id");

CREATE INDEX IF NOT EXISTS "user_limit_idx" ON "user_limit" ("user_id");