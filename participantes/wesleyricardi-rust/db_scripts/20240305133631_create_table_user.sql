DROP TABLE IF EXISTS "user_limit" CASCADE;

CREATE TABLE
  IF NOT EXISTS "user_limit" (
    "user_id" SERIAL PRIMARY KEY,
    "limit" BIGINT NOT NULL
  );