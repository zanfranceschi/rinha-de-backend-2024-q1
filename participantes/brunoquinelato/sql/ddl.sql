SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;
SET default_tablespace = '';
SET default_table_access_method = heap;

CREATE UNLOGGED TABLE "customers" (
    "id" SERIAL PRIMARY KEY,
    "limit_amount" INT NOT NULL,
    "balance" INT NOT NULL  
);

CREATE UNLOGGED TABLE "transactions" (
    "id" SERIAL PRIMARY KEY,
    "customer_id" INT NOT NULL,
    "type" CHAR(1) NOT NULL,
    "amount" INT NOT NULL,
    "description" VARCHAR(10) NOT NULL,
    "created_at" timestamp
);

CREATE INDEX idx_transactions 
ON transactions (customer_id asc);