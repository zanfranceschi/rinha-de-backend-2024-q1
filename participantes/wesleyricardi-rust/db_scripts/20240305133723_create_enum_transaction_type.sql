DROP TYPE IF EXISTS "transaction_type" CASCADE;

CREATE TYPE "transaction_type" as ENUM ('c', 'd');