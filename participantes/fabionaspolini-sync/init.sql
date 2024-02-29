create unlogged table cliente (
	id integer primary key not null,
    saldo integer not null,
   	limite integer not null);
    
create unlogged table transacao (
    id serial primary key not null,
    cliente_id integer not null,
    tipo char(1) not null,
    valor integer not null,
    realizada_em timestamptz not null,
    descricao varchar(10) not null);
   
create index ix_transacao_cliente_data on transacao(cliente_id, realizada_em desc);

insert into cliente(id, limite, saldo) values
(1, 100000, 0),
(2, 80000, 0),
(3, 1000000, 0),
(4, 10000000, 0),
(5, 500000, 0);

create type inserir_transacao_result as (
	result_code int,
	result_message varchar(100),
	saldo integer,
	limite integer);

/*
 * 0: OK
 * 1: Cliente inválido.
 * 2: Saldo e limite insuficiente para executar a operação.
 */

-- data type
create or replace function inserir_transacao_credito(
    cliente_id int,
    valor int,
    descricao varchar(10))
returns inserir_transacao_result as $func$
declare
    cli cliente%rowtype;
    result inserir_transacao_result;
begin
    /* Se for crédito, não valida estouro de limite*/
    update cliente
    set saldo = saldo + valor
    where id = cliente_id
    returning *
    into cli;
    
    if not found then
        select 1, 'Cliente inválido.', null, null into result;
        return result;
    end if;

    insert into transacao(cliente_id, tipo, valor, realizada_em, descricao)
    values (cliente_id, 'c', valor, now(), descricao);

    select 0, null, cli.saldo, cli.limite into result;
    return result;
end;
$func$ language plpgsql;

create or replace function inserir_transacao_debito(
    cliente_id int,
    valor int,
    descricao varchar(10))
returns inserir_transacao_result as $func$
declare
    cli cliente%rowtype;
    result inserir_transacao_result;
begin
    /* Se for débito, valida estouro de limite*/
    update cliente
    set saldo = saldo - valor
    where id = cliente_id
      and saldo - valor + limite >= 0 
    returning *
    into cli;
   
    if not found then
        if not exists(select 1 from cliente where id = cliente_id) then
            select 1, 'Cliente inválido.', null, null into result;
            return result;
        end if;
    
        select 2, 'Saldo e limite insuficiente para executar a operação.', null, null into result;
        return result;
    end if;


    insert into transacao(cliente_id, tipo, valor, realizada_em, descricao)
    values (cliente_id, 'd', valor, now(), descricao);

    select 0, null, cli.saldo, cli.limite into result;
    return result;
end;
$func$ language plpgsql;