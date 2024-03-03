SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_min_messages = warning;
SET row_security = off;

-- Table: public.CLIENTE

-- DROP TABLE IF EXISTS public."CLIENTE";

CREATE UNLOGGED TABLE IF NOT EXISTS public."CLIENTE"
(
    "ID_CLIENTE" integer NOT NULL,
    "NR_LIMITE" integer NOT NULL,
    "NR_SALDO" integer NOT NULL,
    CONSTRAINT "CLIENTE_pkey" PRIMARY KEY ("ID_CLIENTE")
);

CREATE INDEX IF NOT EXISTS "IDX_NR_LIMITE"
    ON "CLIENTE" USING btree
    ("NR_LIMITE" ASC NULLS LAST, "NR_SALDO" ASC NULLS LAST)
    WITH (deduplicate_items=True);

CREATE UNLOGGED TABLE IF NOT EXISTS public."TRANSACAO"
(
    "ID_TRANSACAO" integer NOT NULL,
    "ID_CLIENTE" integer NOT NULL,
    "NR_VALOR" integer,
    "CD_TYPE" character varying(1) COLLATE pg_catalog."default",
    "DS_TRANSACAO" character varying(10) COLLATE pg_catalog."default",
    "DT_REALIZADO" timestamp(3) without time zone,
    CONSTRAINT "TRANSACAO_pkey" PRIMARY KEY ("ID_TRANSACAO")
);



INSERT INTO "CLIENTE" ("ID_CLIENTE", "NR_SALDO", "NR_LIMITE") VALUES (1, 0, -100000);
INSERT INTO "CLIENTE" ("ID_CLIENTE", "NR_SALDO", "NR_LIMITE") VALUES (2, 0, -80000);
INSERT INTO "CLIENTE" ("ID_CLIENTE", "NR_SALDO", "NR_LIMITE") VALUES (3, 0, -1000000);
INSERT INTO "CLIENTE" ("ID_CLIENTE", "NR_SALDO", "NR_LIMITE") VALUES (4, 0, -10000000);
INSERT INTO "CLIENTE" ("ID_CLIENTE", "NR_SALDO", "NR_LIMITE") VALUES (5, 0, -500000);


INSERT INTO "TRANSACAO" ("ID_TRANSACAO", "ID_CLIENTE", "NR_VALOR", "CD_TYPE", "DS_TRANSACAO", "DT_REALIZADO") VALUES (1, 1, 0, 'S', 'SYSTEM', NOW());
INSERT INTO "TRANSACAO" ("ID_TRANSACAO", "ID_CLIENTE", "NR_VALOR", "CD_TYPE", "DS_TRANSACAO", "DT_REALIZADO") VALUES (2, 2, 0, 'S', 'SYSTEM', NOW());
INSERT INTO "TRANSACAO" ("ID_TRANSACAO", "ID_CLIENTE", "NR_VALOR", "CD_TYPE", "DS_TRANSACAO", "DT_REALIZADO") VALUES (3, 3, 0, 'S', 'SYSTEM', NOW());
INSERT INTO "TRANSACAO" ("ID_TRANSACAO", "ID_CLIENTE", "NR_VALOR", "CD_TYPE", "DS_TRANSACAO", "DT_REALIZADO") VALUES (4, 4, 0, 'S', 'SYSTEM', NOW());
INSERT INTO "TRANSACAO" ("ID_TRANSACAO", "ID_CLIENTE", "NR_VALOR", "CD_TYPE", "DS_TRANSACAO", "DT_REALIZADO") VALUES (5, 5, 0, 'S', 'SYSTEM', NOW());


CREATE OR REPLACE VIEW public."TRANSACAO_VW"
 AS
 SELECT a."NR_LIMITE",
    a."ID_CLIENTE",
    a."NR_SALDO",
    b."NR_VALOR",
    b."CD_TYPE",
    b."DS_TRANSACAO",
    b."DT_REALIZADO",
    to_char(b."DT_REALIZADO", 'YYYY-MM-DD"T"HH:MI:SS:MS"Z"'::text) AS dt_realizado_formatted
   FROM "CLIENTE" a
     JOIN "TRANSACAO" b ON b."ID_CLIENTE" = a."ID_CLIENTE";

CREATE UNLOGGED SEQUENCE IF NOT EXISTS public.transacao_seq
    INCREMENT 1
    START 10;

CREATE OR REPLACE FUNCTION public.fn_criar_transacao_v2(
	p_id_cliente integer,
	p_nr_value integer,
	p_cd_type character varying,
	p_ds_transacao character varying)
    RETURNS TABLE(nr_saldo integer, nr_limite integer, bl_result integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE
   P_OUT_SALDO int := 0;
   P_OUT_LIMITE int := 0;
   P_OUT_RESULT int := 0;
   
   P_RETURN RECORD;
   
begin
    

    UPDATE "CLIENTE"
       SET "NR_SALDO" = "NR_SALDO" + "p_nr_value"
    WHERE "ID_CLIENTE" = "p_id_cliente"
      AND "NR_LIMITE" <= ("NR_SALDO" + "p_nr_value")
    RETURNING "NR_SALDO", ABS("NR_LIMITE")	INTO P_OUT_SALDO, P_OUT_LIMITE;
	
    IF P_OUT_SALDO is not null THEN
		
        INSERT INTO "TRANSACAO" ("ID_TRANSACAO", "ID_CLIENTE", "NR_VALOR", "CD_TYPE", "DS_TRANSACAO", "DT_REALIZADO")
        VALUES
        (
			nextval('transacao_seq'),
            "p_id_cliente",
            "p_nr_value",
            "p_cd_type",
            "p_ds_transacao",
            NOW()
        );

        P_OUT_RESULT := 1;
    END IF;

	RETURN QUERY SELECT P_OUT_RESULT  BL_RESULT,  P_OUT_SALDO  NR_SALDO, P_OUT_LIMITE  NR_LIMITE;
    

END;
$BODY$;

