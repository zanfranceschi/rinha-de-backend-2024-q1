-- This file allow to write SQL commands that will be emitted in test and dev.
create table Cliente (
    id serial,
    limite bigint,
    primary key (id)
);

create table Saldo (
     id serial,
     cliente_id bigint not null,
     saldo bigint,
     primary key (id)
);

create table Transacao (
    id serial,
    tipo char(1),
    cliente_id bigint not null,
    valor bigint,
    descricao varchar(255),
    realizada_em timestamp,
    primary key (id)
);

alter table if exists Transacao
    add constraint TransacaoClienteFK
    foreign key (cliente_id)
    references Cliente;

alter table if exists Saldo
    add constraint SaldoClienteFK
    foreign key (cliente_id)
    references Cliente;
