CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    limite INT,
    saldo INT DEFAULT 0
);

CREATE TABLE transacoes (
    id SERIAL PRIMARY KEY,
    id_cliente INT REFERENCES clientes(id),
    tipo VARCHAR(1),
    descricao VARCHAR(10),
    valor INT,
    realizada_em TIMESTAMP
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