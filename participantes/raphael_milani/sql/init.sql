--create database rinhabackend2024;

CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE SEQUENCE cliente_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;


CREATE SEQUENCE transacao_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;


CREATE UNLOGGED TABLE IF NOT EXISTS  cliente (
	id int8 NOT NULL,
	limite int8 NULL,
	saldo int8 NULL,
	version int8 NULL,
	CONSTRAINT cliente_pkey PRIMARY KEY (id)
);


create index cliente_id_idx on cliente (id);


CREATE UNLOGGED TABLE IF NOT EXISTS  transacao (
	id int8 NOT NULL,
	descricao varchar(255) NULL,
	realizada_em timestamp(6) NULL,
	tipo_transacao varchar(255) NULL,
	valor int8 NULL,
	id_cliente int8 NOT NULL
);

ALTER TABLE transacao ADD CONSTRAINT transacao_pkey PRIMARY KEY (id);

ALTER TABLE transacao ADD CONSTRAINT fk_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id);

CREATE INDEX CONCURRENTLY ON transacao (id_cliente, realizada_em); 


INSERT INTO public.cliente
(id, limite, saldo ,version)
VALUES(nextval('cliente_seq'), 100000, 0,1);
INSERT INTO public.cliente
(id, limite, saldo ,version)
VALUES(nextval('cliente_seq'), 80000, 0,1);
INSERT INTO public.cliente
(id, limite, saldo ,version)
VALUES(nextval('cliente_seq'), 1000000, 0,1);
INSERT INTO public.cliente
(id, limite, saldo ,version)
VALUES(nextval('cliente_seq'), 10000000, 0,1);
INSERT INTO public.cliente
(id, limite, saldo,version)
VALUES(nextval('cliente_seq'), 500000, 0,1);
