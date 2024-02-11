CREATE TABLE public.cliente (
	id SERIAL PRIMARY KEY,
	limite INTEGER NOT NULL -- poderia ter tirado, n tirei por preguiça
);

CREATE TABLE public.saldocliente (
	id INTEGER PRIMARY KEY NOT NULL, -- id do cliente
	-- Dupliquei, é a vida.
	limite INTEGER NOT NULL,
  	saldo INTEGER NOT NULL
);

CREATE TABLE public.transacao (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL,
	-- Dupliquei, é a vida.
	limite INTEGER NOT NULL,
  	saldo INTEGER NOT NULL
);

CREATE INDEX transacoes_index ON public.transacao (cliente_id, id desc) INCLUDE (valor, tipo, descricao, realizada_em, limite, saldo);
create sequence Cliente_SEQ start with 1 increment by 50;
INSERT INTO public.cliente (id, limite)
	VALUES
		(1, 1000 * 100),
		(2, 800 * 100),
		(3, 10000 * 100),
		(4, 100000 * 100),
		(5, 5000 * 100);

INSERT INTO public.saldocliente (id, limite, saldo)
	VALUES
		(1, 1000 * 100, 0),
		(2, 800 * 100, 0),
		(3, 10000 * 100, 0),
		(4, 100000 * 100, 0),
		(5, 5000 * 100, 0);
	