CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE TABLESPACE cliente location '/var/lib/postgresql/tablespaces/cliente';
CREATE TABLESPACE tablespace1 location '/var/lib/postgresql/tablespaces/tablespace1';
CREATE TABLESPACE tablespace2 location '/var/lib/postgresql/tablespaces/tablespace2';
CREATE TABLESPACE tablespace3 location '/var/lib/postgresql/tablespaces/tablespace3';
CREATE TABLESPACE tablespace4 location '/var/lib/postgresql/tablespaces/tablespace4';
CREATE TABLESPACE tablespace5 location '/var/lib/postgresql/tablespaces/tablespace5';
CREATE TABLESPACE tablespace6 location '/var/lib/postgresql/tablespaces/tablespace6';
CREATE TABLESPACE tablespace7 location '/var/lib/postgresql/tablespaces/tablespace7';

CREATE TABLE if not exists cliente (
    id      int not null primary key,
    limite  int not null,
    saldo   int not null, CHECK ( saldo + limite >= 0 )
);

insert into cliente (id, limite, saldo) values (1, 100000, 0);
insert into cliente (id, limite, saldo) values (2, 80000, 0);
insert into cliente (id, limite, saldo) values (3, 1000000, 0);
insert into cliente (id, limite, saldo) values (4, 10000000, 0);
insert into cliente (id, limite, saldo) values (5, 500000, 0);

CREATE TABLE if not exists transacao(
    id          serial not null,
    cliente_id  int not null,
    operacao    char(1) not null,
    valor       int not null,
    descricao   varchar(10) not null,
    criacao     timestamp with time zone not null DEFAULT NOW()
) PARTITION BY HASH(cliente_id) tablespace cliente;

CREATE TABLE transacao_1 PARTITION OF transacao FOR VALUES with (modulus 7, remainder 0) tablespace tablespace1;
CREATE TABLE transacao_2 PARTITION OF transacao FOR VALUES with (modulus 7, remainder 1) tablespace tablespace2;
CREATE TABLE transacao_3 PARTITION OF transacao FOR VALUES with (modulus 7, remainder 2) tablespace tablespace3;
CREATE TABLE transacao_4 PARTITION OF transacao FOR VALUES with (modulus 7, remainder 3) tablespace tablespace4;
CREATE TABLE transacao_5 PARTITION OF transacao FOR VALUES with (modulus 7, remainder 4) tablespace tablespace5;
CREATE TABLE transacao_6 PARTITION OF transacao FOR VALUES with (modulus 7, remainder 5) tablespace tablespace6;
CREATE TABLE transacao_7 PARTITION OF transacao FOR VALUES with (modulus 7, remainder 6) tablespace tablespace7;
alter table transacao add constraint pk_transacao primary key(cliente_id,id);
