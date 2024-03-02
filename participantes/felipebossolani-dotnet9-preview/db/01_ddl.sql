CREATE UNLOGGED TABLE clientes (
    id integer PRIMARY KEY NOT NULL,
    saldo integer NOT NULL,
    limite integer NOT NULL
);

CREATE UNLOGGED TABLE transacoes (
    id SERIAL PRIMARY KEY,
    tipo char(1) NOT NULL,
    valor integer NOT NULL,
    descricao varchar(10) NOT NULL,
    realizada_em timestamp NOT NULL,
    idcliente integer NOT NULL
);

ALTER TABLE transacoes
ADD CONSTRAINT fk_transacoes_clientes
FOREIGN KEY (idcliente) REFERENCES clientes(id);

CREATE INDEX ix_transacoes_idcliente ON transacoes
(
    idcliente ASC
);