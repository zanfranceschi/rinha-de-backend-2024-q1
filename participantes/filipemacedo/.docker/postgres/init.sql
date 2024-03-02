
CREATE TABLE clients (
  "id" SERIAL NOT NULL,
  "name" VARCHAR(255) NOT NULL,
  "limit" INTEGER NOT NULL,
  CONSTRAINT "clients_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "balances" (
  "id" SERIAL NOT NULL,
  "idClient" INTEGER NOT NULL,
  "value" INTEGER NOT NULL,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "balances_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "balances_id_client_unique_index" ON "balances" ("idClient");

CREATE TYPE "transaction_type" AS ENUM ('credit', 'debit');

CREATE TABLE "transactions" (
  "id" SERIAL NOT NULL,
  "value" INTEGER NOT NULL,
  "idClient" INTEGER NOT NULL,
  "type" "transaction_type" NOT NULL,
  "description" VARCHAR(10) NOT NULL,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "transactions_pkey" PRIMARY KEY ("id")
);

ALTER TABLE
  "transactions"
ADD
  CONSTRAINT "transactions_id_client_fkey" FOREIGN KEY ("idClient") REFERENCES "clients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

INSERT INTO
  "clients" ("limit", "name")
VALUES
  (1000 * 100, 'Client 1'),
  (800 * 100, 'Client 2'),
  (10000 * 100, 'Client 3'),
  (100000 * 100, 'Client 4'),
  (5000 * 100, 'Client 5');

INSERT INTO
  "balances" ("idClient", "value")
SELECT
  "id",
  0
FROM
  "clients";
