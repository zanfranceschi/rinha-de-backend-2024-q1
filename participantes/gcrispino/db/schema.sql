CREATE TABLE "customers" (
  "id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "limit" integer,
  "balance" integer,
  "created_at" timestamp default current_timestamp
);

CREATE TABLE "transactions" (
  "id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "value" integer,
  "type" char(1),
  "description" varchar(10),
  "customer_id" integer,
  "created_at" timestamp default current_timestamp
);

ALTER TABLE "transactions" ADD FOREIGN KEY ("customer_id") REFERENCES "customers" ("id");
