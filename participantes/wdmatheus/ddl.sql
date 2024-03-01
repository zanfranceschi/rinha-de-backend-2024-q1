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

create unlogged table public.clientes
(
    id serial not null,
    nome varchar(100) not null,
    limite integer not null,
    saldo integer not null,
    constraint pk_clientes primary key(id)
);

create unlogged table public.transacoes
(
    id serial not null,
    valor integer not null,
    cliente_id integer not null,
    tipo integer not null,
    descricao varchar(10) not null,    
    realizada_em timestamp not null default (now() at time zone 'utc'),
    constraint pk_transacoes primary key(id)
);


create index ix_transacoes_cliente_id on transacoes(cliente_id asc);

-------------------------- proc criar_transacao --------------------------
create or replace procedure public.criar_transacao
( 
	cliente_id integer,
	valor integer,
	tipo integer,
	descricao varchar(10),
	inout "ClienteId" integer default null,
	inout "Limite" integer default null,
	inout "Saldo" integer default null,
    inout "TransacaoFoiCriada" boolean default false
)
language plpgsql
as $proc$
begin
    select
        c.id
    from
        public.clientes c
        into "ClienteId"
    where
        c.id = cliente_id;
    
    if "ClienteId" is null then
        select
            0, 0, 0, false
        into "ClienteId", "Limite", "Saldo", "TransacaoFoiCriada";
        return;
    end if;
    
    update public.clientes
        set saldo =
            case
                when tipo = 1 then saldo + valor
                else saldo + valor * -1
            end
        where id = cliente_id and
        (
            case
                when tipo = 1 then true
                else
                    (abs(saldo + (valor * -1)) <= limite)
                end
        ) = true
        returning limite, saldo
        into "Limite", "Saldo";
    
    if "Limite" is null then
        select
            "ClienteId", 0, 0, false
        into "ClienteId", "Limite", "Saldo", "TransacaoFoiCriada";
        return;
    end if;
    
    insert into public.transacoes
        (valor, tipo, descricao, cliente_id)
    values
        (
            valor,
            tipo,
            descricao,
            cliente_id
        );
    
    select
        "ClienteId","Limite", "Saldo", true
        into "ClienteId", "Limite", "Saldo", "TransacaoFoiCriada";
end
$proc$;

-------------------------- vw_extrato --------------------------
create or replace view vw_extrato
as
select
    j.id,
    json_build_object
    (
        'saldo',
        json_build_object
        (
            'limite',
            j.limite,

            'total',
            j.total,

            'data_extrato',
            to_char(j.data_extrato, 'YYYY-MM-DD"T"HH24:MI:US"Z"')
        ),

        'ultimas_transacoes',
        coalesce(j.ultimas_transacoes, '{}')
    ) as extrato
from
    (
        select
            c.id,
            c.saldo as total,
            c.limite,
            now() at time zone 'utc' as data_extrato,
            (
                select
                    array_agg(t)
                from
                    (

                        select
                            t.valor,
                            t.descricao,
                            to_char(t.realizada_em, 'YYYY-MM-DD"T"HH24:MI:US"Z"') as realizada_em,
                            case
                                when t.tipo = 1 then 'c'
                                else 'd'
                            end as tipo
                        from
                            public.transacoes t
                        where
                            t.cliente_id = c.id
                        order by
                            t.realizada_em desc
                            limit 10

                    ) as t
            ) as ultimas_transacoes
        from
            public.clientes c

    ) j;


-------------------------- carga inicial --------------------------
DO $$
begin
insert into public.clientes (id, nome, saldo, limite)
values
    (1, 'o barato sai caro', 0, 100000),
    (2, 'zan corp ltda', 0, 80000),
    (3, 'les cruders', 0, 1000000),
    (4, 'padaria joia de cocaia', 0, 10000000),
    (5, 'kid mais', 0, 500000);
end; $$

