
    create sequence saldo_SEQ start with 1 increment by 50;

    create sequence transacao_SEQ start with 1 increment by 50;

    create table saldo (
        limite integer,
        total integer,
        id bigint not null,
        primary key (id)
    );

    create table transacao (
        tipo varchar(1),
        valor integer,
        id bigint not null,
        realizada_em timestamp(6) with time zone,
        saldo_id bigint,
        descricao varchar(10),
        primary key (id)
    );

    alter table if exists transacao 
       add constraint FKf375low74a2iyfxep0bk2maek 
       foreign key (saldo_id) 
       references saldo;
insert into saldo (id, total, limite) values (1, 0, 100000);
insert into saldo (id, total, limite) values (2, 0, 80000);
insert into saldo (id, total, limite) values (3, 0, 1000000);
insert into saldo (id, total, limite) values (4, 0, 10000000);
insert into saldo (id, total, limite) values (5, 0, 500000);
