CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    limite INTEGER NOT NULL,
    saldo INTEGER NOT NULL
);

CREATE TABLE transacoes (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    valor INTEGER NOT NULL,
    tipo TEXT NOT NULL,
    descricao TEXT NOT NULL,
    realizada_em TIMESTAMP WITH TIME ZONE NOT NULL
);

insert into clientes (limite,saldo) values (100000,	0),(80000,	0),(1000000,	0),(10000000,	0),(500000,	0);



UPDATE public."clientes" SET "saldo"= 0;

DELETE from "transacoes";

