CREATE UNLOGGED  TABLE clientes (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	limite INTEGER NOT NULL,
	saldo INTEGER  NOT NULL
);

CREATE UNLOGGED  TABLE transacoes (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX transacoes_cliente_id_idx ON transacoes (cliente_id);
-- CREATE INDEX cliente_id_idx ON clientes (id) include (limite, saldo);



CREATE OR REPLACE FUNCTION public.update_saldo_cliente(p_cliente_id integer, p_valor bigint, p_tipo character varying, p_descricao character varying)
 RETURNS TABLE(new_saldo integer, limite integer, erro character varying)
 LANGUAGE plpgsql
AS $function$
DECLARE
  saldo INTEGER;
  limite INTEGER;
  new_saldo INTEGER;
  erro character varying;
BEGIN
  SELECT c.saldo, c.limite INTO saldo, limite
  FROM clientes c
  WHERE c.id = p_cliente_id FOR UPDATE;
 
  IF NOT FOUND THEN
    erro = 'P0002';
    RETURN QUERY SELECT saldo, limite, erro;
    return;
  END IF;

  IF p_tipo = 'd' THEN
    new_saldo := saldo - p_valor;
    IF new_saldo + limite < 0 THEN
     erro = 'P0001';
     RETURN QUERY SELECT saldo, limite, erro;
     return;
    END IF;
  ELSE
    new_saldo := saldo + p_valor;
  END IF;

  UPDATE clientes c SET saldo = new_saldo WHERE c.id = p_cliente_id;

  INSERT INTO transacoes (cliente_id, tipo, valor, descricao, realizada_em)
  VALUES (
    p_cliente_id,
    p_tipo,
    p_valor,
    p_descricao,
    CURRENT_TIMESTAMP
  );

  RETURN QUERY SELECT new_saldo, limite, erro;
END;
$function$
;






DO $$
BEGIN
	INSERT INTO clientes (nome, limite, saldo)
	VALUES
		('o barato sai caro', 1000 * 100, 0),
		('zan corp ltda', 800 * 100, 0),
		('les cruders', 10000 * 100, 0),
		('padaria joia de cocaia', 100000 * 100, 0),
		('kid mais', 5000 * 100, 0);
END;
$$;

CREATE EXTENSION IF NOT EXISTS pg_prewarm;
SELECT pg_prewarm('clientes');
SELECT pg_prewarm('transacoes');

