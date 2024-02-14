-- Coloque scripts iniciais aqui
CREATE TABLE clientes (
    id INT GENERATED ALWAYS AS IDENTITY,
    nome text NOT NULL,
    limite integer NOT NULL,
    saldo integer NOT NULL default 0,
    PRIMARY KEY(id)
);

CREATE TABLE transacoes (
    id INT GENERATED ALWAYS AS IDENTITY,
    valor integer NOT NULL,
    tipo character(1) NOT NULL,
    descricao varchar(10) NOT NULL,
    realizada_em timestamp with time zone NOT NULL,
    cliente_id integer NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT fk_cliente
      FOREIGN KEY(cliente_id) 
        REFERENCES clientes(id)
);

DO $$
BEGIN
  INSERT INTO clientes (nome, limite)
  VALUES
    ('o barato sai caro', 1000 * 100),
    ('zan corp ltda', 800 * 100),
    ('les cruders', 10000 * 100),
    ('padaria joia de cocaia', 100000 * 100),
    ('kid mais', 5000 * 100);
END; $$