CREATE sequence Cliente_SEQ start with 1 increment by 50;

CREATE sequence Transacao_SEQ start with 1 increment by 50;

CREATE TABLE cliente (
                         id bigint not null,
                         limite integer,
                         saldo integer,
                         primary key (id)
);

CREATE TABLE transacao (
                           id bigint not null,
                           descricao varchar(10),
                           realizada_em timestamp(6),
                           tipo char(1) not null,
                           valor integer not null,
                           cliente_id bigint,
                           primary key (id)
);

INSERT INTO cliente (id, limite, saldo) VALUES
                                            (1, 100000, 0),
                                            (2, 80000, 0),
                                            (3, 1000000, 0),
                                            (4, 10000000, 0),
                                            (5, 500000, 0);