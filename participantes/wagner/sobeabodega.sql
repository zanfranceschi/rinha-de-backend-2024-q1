-- CREATE DATABASE
CREATE DATABASE RinhaDeBackend;

-- USE DATABASE
\c RinhaDeBackend;

-- CREATE CUSTOMERS TABLE
CREATE UNLOGGED TABLE public."Customers" (
    "Id" serial,
    "Limit" int NOT NULL,
    "Balance" int NOT NULL
);
 CREATE INDEX customers_id_idx ON public."Customers" ("Id");

-- INSERT DEFAULT VALUES INTO MAIN TABLE
INSERT INTO public."Customers" ("Limit", "Balance")
VALUES
(100000, 0),
(80000, 0),
(1000000, 0),
(10000000, 0),
(500000, 0);

-- CREATE TABLES FOR TRANSACTIONS
DO $$ 
DECLARE
    customer_id INT;
BEGIN
    FOR customer_id IN (select distinct public."Customers"."Id" from public."Customers") LOOP
        EXECUTE FORMAT('
CREATE UNLOGGED TABLE public."Transactions_%s" (
	"Id" serial,
    "Amount" int NOT NULL,
    "Type" varchar(1) NOT NULL,
    "Description" varchar(10) NOT NULL,
    "DateTime" timestamp DEFAULT now()
);
CREATE INDEX transactions_customer_%s_idx ON public."Transactions_%s" ("Id" DESC);
        ', customer_id, customer_id, customer_id);
    END LOOP;
END $$;


