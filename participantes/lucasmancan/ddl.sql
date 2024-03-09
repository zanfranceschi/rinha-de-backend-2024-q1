SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

SET default_tablespace = '';

SET default_table_access_method = heap;

DROP TABLE IF EXISTS public.clientes;

CREATE UNLOGGED TABLE public.clientes (
    cliente_id serial not null,
    nome varchar(32) not null,
    data_criacao timestamp not null default current_timestamp,
    limite bigint not null,
    saldo bigint not null default 0,
    versao bigint not null default 0,
    primary key (cliente_id)
);

CREATE UNLOGGED TABLE public.transacoes (
    id serial not null,
    cliente_id int not null,
    realizada_em timestamp not null default current_timestamp,
    valor bigint not null,
    tipo char not null,
    descricao varchar(10) null,
    primary key (id)
);

CREATE INDEX idx_transacoes_id_cliente ON transacoes
(
    cliente_id ASC
);

  INSERT INTO public.clientes (nome, limite)
  VALUES
    ('o barato sai caro', 100000),
    ('zan corp ltda', 80000),
    ('les cruders', 1000000),
    ('padaria joia de cocaia', 10000000),
    ('kid mais', 500000);

