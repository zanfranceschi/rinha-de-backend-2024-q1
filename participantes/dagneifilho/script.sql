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


CREATE TABLE "Clientes" (
    "Id" SERIAL PRIMARY KEY,
    "Limite" int NOT NULL,
    "Saldo" int NOT NULL,
    "Nome" VARCHAR(50)
);
CREATE TABLE "Transacoes" (
    "Id" SERIAL PRIMARY KEY,
    "Valor" int NOT NULL,
    "Tipo" char NOT NULL,
    "Descricao" VARCHAR(10) NOT NULL,
    "RealizadaEm" timestamp NOT NULL,
    "ClienteId" int NOT NULL,
    CONSTRAINT "FK_Transacoes_Clientes_ClienteId" FOREIGN KEY ("ClienteId") REFERENCES "Clientes" ("Id")
);

CREATE INDEX index_idCliente_transacoes ON "Transacoes"("ClienteId" ASC);
DO $$
BEGIN
  INSERT INTO "Clientes" ("Nome", "Limite", "Saldo")
  VALUES
    ('o barato sai caro', 1000 * 100,0),
    ('zan corp ltda', 800 * 100,0),
    ('les cruders', 10000 * 100,0),
    ('padaria joia de cocaia', 100000 * 100,0),
    ('kid mais', 5000 * 100,0);
END; $$
