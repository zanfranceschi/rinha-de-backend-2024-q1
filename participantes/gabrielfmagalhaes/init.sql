CREATE TABLE clientes (
    id integer PRIMARY KEY NOT NULL,
    nome varchar(25) NOT NULL,
    saldo integer NOT NULL,
    limite integer NOT NULL
);

CREATE TABLE transacoes (
    id SERIAL PRIMARY KEY,
    clienteId integer NOT NULL,
    tipo char(1) NOT NULL,
    valor integer NOT NULL,
    descricao varchar(10) NOT NULL,
    efetuadaEm timestamp NOT NULL
);

CREATE INDEX fk_transacao_clienteid ON transacoes
(
    clienteId ASC
);

DELETE FROM transacoes;
DELETE FROM clientes;

INSERT INTO clientes (id, nome, saldo, limite)
  VALUES
    (1, 'o barato sai caro', 0, 1000 * 100),
    (2, 'zan corp ltda', 0, 800 * 100),
    (3, 'les cruders', 0, 10000 * 100),
    (4, 'padaria joia de cocaia', 0, 100000 * 100),
    (5, 'kid mais', 0, 5000 * 100);