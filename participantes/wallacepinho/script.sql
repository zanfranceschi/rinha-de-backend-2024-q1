create schema rinha;

-- tables
create table rinha.cliente (
    id integer,
    limite integer,
    saldo integer
);

create table rinha.transacao (
    cliente_id integer,
    valor integer,
    tipo varchar(1),
    descricao varchar(10),
    realizada_em timestamp
);

-- data
insert into rinha.cliente(id, limite, saldo) values 
(1, 100000, 0),
(2, 80000, 0),
(3, 1000000, 0),
(4, 10000000, 0),
(5, 500000, 0);