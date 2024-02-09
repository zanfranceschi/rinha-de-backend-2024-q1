CREATE TABLE IF NOT EXISTS public.clients
(
    id INTEGER NOT NULL,
    limite INTEGER NOT NULL,
    saldo INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT clients_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.transactions
(
    id SERIAL NOT NULL,
    valor INTEGER NOT NULL,
    tipo_transacao CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    criada_em timestamp without time zone DEFAULT now(),
    id_cliente INTEGER NOT NULL,
    CONSTRAINT transactions_pkey PRIMARY KEY (id),
    CONSTRAINT fk_client_transaction FOREIGN KEY (id_cliente) REFERENCES clients(id)
);

CREATE INDEX IF NOT EXISTS idx_client_id ON public.clients (id);
CREATE INDEX IF NOT EXISTS idx_client_tranction_id ON public.transactions (id_cliente);

INSERT INTO public.clients
VALUES  (1, 100000, 0),
        (2, 80000, 0),
        (3, 1000000, 0),
        (4, 10000000, 0),
        (5, 500000, 0);
