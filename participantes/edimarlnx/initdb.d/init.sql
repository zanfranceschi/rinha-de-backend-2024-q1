drop table if exists clientes;
create table clientes
(
    id           serial NOT NULL primary key,
    saldo        int    not null,
    limite       int    not null,
    data_extrato timestamp WITH TIME ZONE not null default CURRENT_TIMESTAMP
);
drop table if exists transacoes;
create table transacoes
(
    id           serial  NOT NULL primary key,
    cliente_id   integer NOT NULL REFERENCES clientes (id),
    valor        int     not null,
    tipo         char(1)     not null,
    descricao    varchar(10),
    realizada_em timestamp WITH TIME ZONE not null default CURRENT_TIMESTAMP
);

create index transacoes_cliente_id_realizado_em ON transacoes
    USING btree (cliente_id, realizada_em);

insert into clientes
    (id, saldo, limite)
VALUES (1, 0, 100000),
       (2, 0, 80000),
       (3, 0, 1000000),
       (4, 0, 10000000),
       (5, 0, 500000);
