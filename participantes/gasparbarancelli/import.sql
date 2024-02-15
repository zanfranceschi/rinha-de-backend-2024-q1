CREATE UNLOGGED TABLE public.CLIENTE (
                                ID SERIAL PRIMARY KEY,
                                LIMITE INT NOT NULL,
                                SALDO INT NOT NULL DEFAULT 0
) WITH (autovacuum_enabled = false);

CREATE UNLOGGED TABLE public.TRANSACAO (
                                  ID SERIAL PRIMARY KEY,
                                  CLIENTE_ID INT NOT NULL,
                                  VALOR INT NOT NULL,
                                  TIPO CHAR(1) NOT NULL,
                                  DESCRICAO VARCHAR(10) NOT NULL,
                                  DATA TIMESTAMP NOT NULL
) WITH (autovacuum_enabled = false);

CREATE INDEX IDX_TRANSACAO_CLIENTE ON TRANSACAO (CLIENTE_ID ASC);

INSERT INTO public.CLIENTE (ID, LIMITE)
VALUES (1, 100000),
       (2, 80000),
       (3, 1000000),
       (4, 10000000),
       (5, 500000);