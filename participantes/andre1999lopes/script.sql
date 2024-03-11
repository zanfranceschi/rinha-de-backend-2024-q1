CREATE TABLE usuarios (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  limite int NOT NULL,
  saldo int NOT NULL
);

CREATE TABLE transacoes (
  id SERIAL PRIMARY KEY,
  usuario_id INT NOT NULL REFERENCES usuarios(id),
  valor int NOT NULL,
  tipo CHAR(1) NOT NULL,
  descricao VARCHAR(10) NOT NULL,
  realizada_em TIMESTAMP NOT NULL
);

INSERT INTO usuarios (nome, limite, saldo) VALUES
  ('o barato sai caro', 100000, 0),
  ('zan corp ltda', 80000, 0),
  ('les cruders', 1000000, 0),
  ('padaria joia de cocaia', 10000000, 0),
  ('kid mais', 500000, 0);