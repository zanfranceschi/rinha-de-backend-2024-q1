create table clients
(
    id     bigserial not null,
    limite bigint,
    saldo  bigint,
    primary key (id)
);

create table transactions
(
    id               bigserial   not null,
    create_at        timestamp(6) with time zone,
    description      varchar(20),
    type_transaction varchar(1),
    value            bigint,
    client_id        bigint,
    primary key (id)
);

alter table if exists transactions add constraint FKjp6w7dmqrj0h9vykk2pbtik2 foreign key (client_id) references clients;

create index if not exists transactions_order_date on transactions using btree (create_at desc);

DO
$$
BEGIN
insert into clients(id, limite, saldo)
values (1,   1000 * 100, 0),
       (2,    800 * 100, 0),
       (3,  10000 * 100, 0),
       (4, 100000 * 100, 0),
       (5,   5000 * 100, 0);
END;
$$;
