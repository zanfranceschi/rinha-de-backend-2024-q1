CREATE TYPE tipo_transacao AS ENUM ('c', 'd');
CREATE UNLOGGED TABLE clientes (
     id serial PRIMARY KEY,
     limite integer NOT NULL,
     saldo integer NOT NULL DEFAULT 0
);
CREATE UNLOGGED TABLE transacoes (
     id serial PRIMARY KEY,
     cliente_id integer REFERENCES clientes(id) NOT NULL,
     tipo tipo_transacao NOT NULL,
     valor integer NOT NULL,
     descricao varchar(40) NOT NULL CHECK (descricao <> ''),
     realizada_em timestamp with time zone DEFAULT current_timestamp
);
CREATE INDEX idx_transacoes_cliente_id ON transacoes (cliente_id ASC);
