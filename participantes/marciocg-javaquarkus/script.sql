
    create table saldo (
        id serial not null,
        limite integer,
        total integer,
        primary key (id)
    );

    create table transacoes (
        id serial not null,
        saldo_id integer,
        tipo varchar(1),
        valor integer,
        descricao varchar(255),
        realizadaEm varchar(255),
        primary key (id)
    );

    alter table if exists transacoes 
       add constraint FK5glwy1bhv9crnua3fowa6ursf 
       foreign key (saldo_id) 
       references saldo;
insert into saldo (id, total, limite) values (1, 0, 100000);
insert into saldo (id, total, limite) values (2, 0, 80000);
insert into saldo (id, total, limite) values (3, 0, 1000000);
insert into saldo (id, total, limite) values (4, 0, 10000000);
insert into saldo (id, total, limite) values (5, 0, 500000);
