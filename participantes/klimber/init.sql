-- This file allow to write SQL commands that will be emitted in test and dev.
create UNLOGGED table Cliente (
    id serial primary key,
    limite bigint
);

create UNLOGGED table Transacao (
    id serial primary key,
    tipo char(1),
    cliente_id bigint references Cliente,
    valor bigint,
    descricao varchar(255),
    realizada_em timestamp,
    saldo bigint
);

insert into Cliente (id, limite) values (1, 100000),
                                        (2, 80000),
                                        (3, 1000000),
                                        (4, 10000000),
                                        (5, 500000);
