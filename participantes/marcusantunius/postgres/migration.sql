SET enable_seqscan = off;

create unlogged table cliente
(
    id     integer primary key,
    limite bigint not null,
    saldo  bigint not null default 0 check ( (abs(limite) - abs(saldo)) > 0 )
);

insert into cliente (id, limite, saldo)
values (1, 100000, 0),
       (2, 80000, 0),
       (3, 1000000, 0),
       (4, 10000000, 0),
       (5, 500000, 0);


create UNLOGGED table transacao
(
    id           serial primary key,
    cliente_id   integer references cliente (id),
    valor        bigint      not null,
    tipo         char        not null,
    descricao    varchar(11) not null,
    realidada_em timestamp   not null default now()

);

create index on transacao (cliente_id);

ALTER TABLE cliente
    SET (autovacuum_enabled = false);

ALTER TABLE transacao
    SET (autovacuum_enabled = false);