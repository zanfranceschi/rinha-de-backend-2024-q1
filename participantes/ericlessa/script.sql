create sequence Transacao_SEQ start with 1 increment by 50;

create UNLOGGED table Transacao (
    id bigint not null,
    valor integer,
    clienteId bigint not null,
    realizada_em timestamp(6),
    descricao varchar(255),
    tipo varchar(255),
    primary key (id)
);

create UNLOGGED table Cliente (
    id bigint not null,
    limite bigint,
    saldo bigint,
    primary key (id)
);

CREATE INDEX ix_transacao_idcliente ON transacao
(
    clienteId
);


  insert into Cliente (limite, saldo, id) values (100000, 0, 1);
  insert into Cliente (limite, saldo, id) values (80000, 0, 2);
  insert into Cliente (limite, saldo, id) values (1000000, 0, 3);
  insert into Cliente (limite, saldo, id) values (10000000, 0, 4);
  insert into Cliente (limite, saldo, id) values (500000, 0, 5);