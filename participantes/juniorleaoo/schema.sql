SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET check_function_bodies = false;
SET row_security = off;

CREATE UNLOGGED TABLE cliente (
    id SERIAL PRIMARY KEY,
    saldo integer NOT NULL,
    limite integer NOT NULL
);

CREATE UNLOGGED TABLE transacao (
    id SERIAL PRIMARY KEY,
    valor integer NOT NULL,
    tipo varchar(1) NOT NULL,
    descricao varchar(10) NOT NULL,
    realizada_em timestamp NOT NULL DEFAULT (now()),
    cliente_id integer NOT NULL
);

CREATE INDEX idx_cliente_id ON transacao(cliente_id);
CREATE INDEX idx_realizada_em ON transacao(realizada_em);

INSERT INTO cliente (id, limite, saldo) VALUES (1, 100000, 0);
INSERT INTO cliente (id, limite, saldo) VALUES (2, 80000, 0);
INSERT INTO cliente (id, limite, saldo) VALUES (3, 1000000, 0);
INSERT INTO cliente (id, limite, saldo) VALUES (4, 10000000, 0);
INSERT INTO cliente (id, limite, saldo) VALUES (5, 500000, 0);