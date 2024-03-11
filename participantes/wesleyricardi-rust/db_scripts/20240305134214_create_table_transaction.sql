DROP TABLE IF EXISTS "transaction" CASCADE;

CREATE TABLE
  IF NOT EXISTS "transaction" (
    "id" SERIAL PRIMARY KEY,
    "type" transaction_type NOT NULL,
    "description" VARCHAR(10) NOT NULL,
    "value" BIGINT NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "user_id" INT NOT NULL,
    "current_balance" BIGINT NOT NULL,
    "previous_transaction_id" INT,
    CONSTRAINT "transaction_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user_limit" ("user_id") ON DELETE RESTRICT ON UPDATE CASCADE
  );

CREATE UNIQUE INDEX IF NOT EXISTS "transaction_previous_transaction_id_key" ON "transaction" ("previous_transaction_id");

ALTER TABLE "transaction" ADD CONSTRAINT "transaction_previous_transaction_id_fkey" FOREIGN KEY ("previous_transaction_id") REFERENCES "transaction" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT;