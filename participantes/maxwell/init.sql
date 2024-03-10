create table if not exists cliente (
    id integer constraint pk_cliente primary key,
    limite bigint not null,
    saldo bigint not null,

    constraint chk_saldo CHECK(saldo >= (-limite))
);

create table if not exists transacao (
    id serial constraint pk_transacao primary key,
    id_cliente integer references cliente(id),
    valor integer not null,
    tipo char not null,
    descricao character varying (10) not null,
    realizada_em timestamp not null default current_timestamp
);

create index CONCURRENTLY idx_transacao_id_cliente ON transacao (id_cliente);
create index CONCURRENTLY idx_transacao_realizada_em ON transacao (realizada_em DESC);

insert into cliente(id, limite, saldo) values(1, 100000, 0);
insert into cliente(id, limite, saldo) values(2, 80000, 0);
insert into cliente(id, limite, saldo) values(3, 1000000, 0);
insert into cliente(id, limite, saldo) values(4, 10000000, 0);
insert into cliente(id, limite, saldo) values(5, 500000, 0);
