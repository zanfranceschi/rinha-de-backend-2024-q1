
CREATE TABLE clients (
  "id" SERIAL NOT NULL,
  "limit" INTEGER NOT NULL,
  CONSTRAINT "clients_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "balances" (
  "id" SERIAL NOT NULL,
  "client_id" INTEGER NOT NULL,
  "value" INTEGER NOT NULL,
  "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT timezone('America/Sao_Paulo', now()),
  CONSTRAINT "balances_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "transactions" (
  "id" SERIAL NOT NULL,
  "value" INTEGER NOT NULL,
  "client_id" INTEGER NOT NULL,
  "operation_type" CHAR(1) NOT NULL,
  "description" VARCHAR(10) NOT NULL,
  "created_at" TIMESTAMP WITH TIME ZONE DEFAULT timezone('America/Sao_Paulo', now()),
  CONSTRAINT "transactions_pkey" PRIMARY KEY ("id"),
  FOREIGN KEY (client_id) REFERENCES clients (id)
);

CREATE UNIQUE INDEX "balances_client_id" ON "balances" ("client_id");

INSERT INTO
  "clients" ("limit")
VALUES
  (100000),
  (80000),
  (1000000),
  (10000000),
  (500000);

INSERT INTO
  "balances" ("client_id", "value")
SELECT
  "id",
  0
FROM
  "clients";
