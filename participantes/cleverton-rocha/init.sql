CREATE EXTENSION IF NOT EXISTS pg_prewarm;

CREATE TYPE public."TipoTransacao" AS ENUM ('c', 'd');

CREATE TABLE public."Cliente" (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(255),
  limite INT DEFAULT 0,
  saldo INT DEFAULT 0
);

CREATE TABLE public."Transacao" (
  id SERIAL PRIMARY KEY,
  id_cliente INT,
  valor INT DEFAULT 0,
  tipo public."TipoTransacao",
  descricao VARCHAR(10),
  realizada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_cliente) REFERENCES public."Cliente"(id)
);

INSERT INTO public."Cliente" (nome, limite)
VALUES
  ('o barato sai caro', 1000 * 100),
  ('zan corp ltda', 800 * 100),
  ('les cruders', 10000 * 100),
  ('padaria joia de cocaia', 100000 * 100),
  ('kid mais', 5000 * 100);
  
SELECT pg_prewarm ('public."Cliente"');

SELECT pg_prewarm ('public."Transacao"');