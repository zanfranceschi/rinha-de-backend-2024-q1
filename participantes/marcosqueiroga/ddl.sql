CREATE UNLOGGED TABLE public.clientes (
	id SERIAL PRIMARY KEY NOT NULL,
	nome VARCHAR(25) NOT NULL,
	limite INT NOT NULL,
	saldo INT NOT NULL
);

CREATE UNLOGGED TABLE public.transacoes (
	id SERIAL PRIMARY KEY NOT NULL,
	valor INT NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL,
	id_cliente INT NOT NULL
);

CREATE INDEX ix_transacoes_id_cliente ON public.transacoes
(
    id_cliente ASC
);

CREATE OR REPLACE FUNCTION public.insere_transacao(
  IN id_cliente INT,
  IN valor INT,
  IN descricao VARCHAR(10)
) RETURNS RECORD AS $$
DECLARE rec_cliente RECORD;
BEGIN
  SELECT limite, saldo FROM public.clientes
    INTO rec_cliente
  WHERE id = id_cliente
  FOR UPDATE;

  IF rec_cliente.limite IS NULL THEN
    SELECT -1 INTO rec_cliente;
	RETURN rec_cliente;
  END IF;

  IF (valor < 0) AND (rec_cliente.saldo + rec_cliente.limite + valor) < 0 THEN
    SELECT -2 INTO rec_cliente;
	RETURN rec_cliente;
  END IF;

  INSERT INTO public.transacoes (valor, descricao, realizada_em, id_cliente)
                         VALUES (valor, descricao, now(), id_cliente);

  UPDATE public.clientes
    SET saldo = saldo + valor
    WHERE id = id_cliente
    RETURNING limite, saldo
    INTO rec_cliente;

  RETURN rec_cliente;
END;$$ LANGUAGE plpgsql;


INSERT INTO public.clientes (nome, limite, saldo)
  VALUES
    ('o barato sai caro', 1000 * 100, 0),
    ('zan corp ltda', 800 * 100, 0),
    ('les cruders', 10000 * 100, 0),
    ('padaria joia de cocaia', 100000 * 100, 0),
    ('kid mais', 5000 * 100, 0);