
CREATE TABLE IF NOT EXISTS "client" (
    "id" SERIAL PRIMARY KEY NOT NULL,
    "credit" BIGINT NOT NULL,
    "current_balance" BIGINT NOT NULL default 0
);

CREATE TABLE IF NOT EXISTS "transaction" (
    "id" SERIAL PRIMARY KEY NOT NULL,
    "client_id" SERIAL NOT NULL,
    "type" character(1) NOT NULL,
    "value" INT NOT NULL,
    "description" varchar(10) NOT NULL default '',
    "created_date" TIMESTAMP default 'now()',
    CONSTRAINT "fk_transaction_client_id" FOREIGN KEY ("client_id") REFERENCES "client" ("id")
);


INSERT INTO client (id, credit, current_balance)
VALUES 
    (1, 100000, 0),
    (2, 80000, 0),
    (3, 1000000, 0),
    (4, 10000000, 0),
    (5, 500000, 0);