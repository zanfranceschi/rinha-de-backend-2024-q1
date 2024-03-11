create table clientes (
    id serial primary key,
    limite integer,
    saldo integer
);

create table transacoes (
    id serial primary key,
    valor integer,
    tipo varchar(1),
    descricao varchar(20),
    data_transacao timestamp,
    id_cliente integer references clientes(id)
);

create index on transacoes (id_cliente);

insert into clientes (limite, saldo) values (100000, 0);
insert into clientes (limite, saldo) values (80000, 0);
insert into clientes (limite, saldo) values (1000000, 0);
insert into clientes (limite, saldo) values (10000000, 0);
insert into clientes (limite, saldo) values (500000, 0);
