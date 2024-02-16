CREATE  TABLE cliente (
    id integer PRIMARY KEY NOT NULL,
    saldo integer NOT NULL,
    limite integer NOT NULL
);

CREATE  TABLE transacao (
    id SERIAL PRIMARY KEY,
    valor integer NOT NULL,
    descricao varchar(10) NOT NULL,
    realizadaem timestamp NOT NULL,
    idcliente integer NOT NULL
);

CREATE INDEX idx_transacao_idcliente ON transacao
(
    idcliente ASC
);

INSERT INTO cliente (id, saldo, limite) VALUES (1, 0, -100000);
INSERT INTO cliente (id, saldo, limite) VALUES (2, 0, -80000);
INSERT INTO cliente (id, saldo, limite) VALUES (3, 0, -1000000);
INSERT INTO cliente (id, saldo, limite) VALUES (4, 0, -10000000);
INSERT INTO cliente (id, saldo, limite) VALUES (5, 0, -500000);