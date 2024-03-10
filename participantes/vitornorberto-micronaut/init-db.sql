begin;
create table if not exists cliente
(
    id     SERIAL primary key,
    limite integer not null,
    saldo  integer not null
);

CREATE INDEX idx_cliente_id ON cliente (id);
commit;

begin;
insert into cliente(id, limite, saldo)
values (1, 100000, 0);
insert into cliente(id, limite, saldo)
values (2, 80000, 0);
insert into cliente(id, limite, saldo)
values (3, 1000000, 0);
insert into cliente(id, limite, saldo)
values (4, 10000000, 0);
insert into cliente(id, limite, saldo)
values (5, 500000, 0);
commit;

begin;
create table if not exists transacao
(
    id         SERIAL primary key,
    valor      integer                        not null,
    descricao  varchar(10)                    not null,
    data       timestamp                      not null,
    tipo       char                           not null,
    cliente_id SERIAL references cliente (id) not null
);

CREATE INDEX idx_transacoes_cliente_id ON transacao (cliente_id);

commit;