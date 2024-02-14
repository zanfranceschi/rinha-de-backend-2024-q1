-- Coloque scripts iniciais aqui

--CREATE TABLE IF NOT EXISTS CLIENTE (
--    CLIENTE_ID INT PRIMARY KEY,
--    SALDO INT NOT NULL,
--    LIMITE INT NOT NULL
--);
--
--CREATE TABLE IF NOT EXISTS TRANSACAO (
--    TRANSACAO_ID INT PRIMARY KEY,
--    CLIENTE_ID INT NOT NULL REFERENCES CLIENTE(CLIENTE_ID),
--    TIPO CHARACTER(1) NOT NULL,
--    VALOR INT NOT NULL,
--    DESCRICAO VARCHAR(10) NOT NULL,
--    REALIZADA_EM TIMESTAMP NOT NULL
--);
--

create table if not exists  cliente (
    cliente_id integer not null,
    limite integer not null,
    saldo integer not null,
    primary key (cliente_id)
);
create table if not exists transacao (
    transacao_id integer not null,
    descricao varchar(255) not null,
    realizada_em timestamp(6) not null,
    tipo char(1) not null,
    valor integer not null,
    cliente_cliente_id integer,
    primary key (transacao_id)
);
create index if not exists REALIZADA_EM_INDEX
   on transacao (realizada_em desc);
create sequence if not exists transacao_seq start with 1 increment by 50;
alter table if exists transacao
   add constraint FK6cqdtt28hwwinbxxayub0wftw
   foreign key (cliente_cliente_id)
   references cliente;

insert into cliente values
    ('1', '100000', '0'),
    ('2', '80000', '0'),
    ('3', '1000000', '0'),
    ('4', '10000000', '0'),
    ('5', '500000', '0');