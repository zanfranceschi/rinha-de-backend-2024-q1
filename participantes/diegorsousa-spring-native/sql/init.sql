create table cliente (
    id bigserial not null,
    limite integer not null,
    saldo integer not null,
    primary key (id)
);

create table transacao (
    id bigserial not null,
    descricao varchar(255),
    tipo char(1),
    valor integer not null,
    cliente_id bigint,
    realizada_em timestamp(6),
    primary key (id),
    foreign key (cliente_id) references cliente(id)
);

create index transacao_fkey on public.transacao using btree (cliente_id);


insert into cliente (id, limite, saldo)
values
    (1, 100000, 0),
    (2, 80000, 0),
    (3, 1000000, 0),
    (4, 10000000, 0),
    (5, 500000, 0);
