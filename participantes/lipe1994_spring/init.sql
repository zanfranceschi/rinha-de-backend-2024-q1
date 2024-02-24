CREATE TABLE public.cliente (
	id int4 NOT NULL,
	limite int4 NOT NULL,
	saldo int4 NOT NULL,
	versao int4 NOT NULL,
	CONSTRAINT cliente_pkey PRIMARY KEY (id)
);

CREATE TABLE public.transacao (
	cliente_id int4 NULL,
	id serial4 NOT NULL,
	tipo bpchar(1) NOT NULL,
	valor int4 NOT NULL,
	criado_em timestamptz(6) NULL,
	descricao varchar(10) NOT NULL,
	CONSTRAINT transacao_pkey PRIMARY KEY (id)
);
ALTER TABLE public.transacao ADD CONSTRAINT transacao_cliente_fk FOREIGN KEY (cliente_id) REFERENCES public.cliente(id);

INSERT INTO public.cliente(id, limite, saldo, versao)VALUES(1, 100000, 0, 0);
INSERT INTO public.cliente(id, limite, saldo, versao)VALUES(2, 80000, 0, 0);
INSERT INTO public.cliente(id, limite, saldo, versao)VALUES(3, 1000000, 0, 0);
INSERT INTO public.cliente(id, limite, saldo, versao)VALUES(4, 10000000, 0, 0);
INSERT INTO public.cliente(id, limite, saldo, versao)VALUES(5, 500000, 0, 0);
