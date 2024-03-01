CREATE TABLE IF NOT EXISTS public.clientes
(
    id SERIAL NOT NULL,
    nome character varying(100) NOT NULL DEFAULT 0,
    limite integer NOT NULL DEFAULT 0,
    saldo integer NOT NULL DEFAULT 0,
    CONSTRAINT clientes_pkey PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS public.transacoes
(
    id SERIAL NOT NULL,
    valor integer NOT NULL DEFAULT 0,
    tipo char NOT NULL DEFAULT 0,
    descricao character varying(100) NOT NULL DEFAULT '',
    realizada_em TIMESTAMP WITH TIME ZONE NOT NULL,
    cliente_id integer NOT NULL,
    CONSTRAINT transacoes_pkey PRIMARY KEY (id),
    CONSTRAINT transacoes_cliente_id_fkey FOREIGN KEY (cliente_id)
        REFERENCES public.clientes (id)
);