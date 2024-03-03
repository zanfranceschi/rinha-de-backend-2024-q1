 CREATE TABLE public.clients (
     id SERIAL PRIMARY KEY,
     "limit" INTEGER NOT NULL,
     balance INTEGER NOT NULL
 );
 
CREATE TABLE public.transaction (
    id SERIAL PRIMARY KEY,
    value INTEGER NOT NULL,
    type CHAR(1) NOT NULL,
    description VARCHAR(10) NOT NULL,
    realized TIMESTAMP NOT NULL DEFAULT NOW(),
    "ClientId" INTEGER,
    CONSTRAINT "FK_transaction_clients_ClientId" FOREIGN KEY ("ClientId") REFERENCES public.clients (id)
);

CREATE INDEX ids_transaction_ids_client_id ON public.transaction ("ClientId");


INSERT INTO public.clients (id, balance, "limit")
VALUES (1, 0, 100000);
INSERT INTO public.clients (id, balance, "limit")
VALUES (2, 0, 80000);
INSERT INTO public.clients (id, balance, "limit")
VALUES (3, 0, 1000000);
INSERT INTO public.clients (id, balance, "limit")
VALUES (4, 0, 10000000);
INSERT INTO public.clients (id, balance, "limit")
VALUES (5, 0, 500000);
