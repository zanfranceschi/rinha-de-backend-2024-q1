SET client_encoding = 'UTF8';
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

CREATE UNLOGGED TABLE cliente (
    id integer PRIMARY KEY NOT NULL,
    saldo integer NOT NULL,
    limite integer NOT NULL
);

CREATE UNLOGGED TABLE transacao (
    id SERIAL PRIMARY KEY,
    valor integer NOT NULL,
    descricao varchar(10) NOT NULL,
    realizadaem timestamp NOT NULL,
    idcliente integer NOT NULL
);

CREATE INDEX ix_transacao_idcliente ON transacao (idcliente DESC);