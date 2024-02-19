-- This file allow to write SQL commands that will be emitted in test and dev.
create UNLOGGED table Cliente (
    id serial,
    limite bigint,
    primary key (id)
);

create UNLOGGED table Transacao (
    id serial,
    tipo char(1),
    cliente_id bigint not null,
    valor bigint,
    descricao varchar(255),
    realizada_em timestamp,
    saldo bigint,
    primary key (id)
);

alter table if exists Transacao
    add constraint TransacaoClienteFK
    foreign key (cliente_id)
    references Cliente;
