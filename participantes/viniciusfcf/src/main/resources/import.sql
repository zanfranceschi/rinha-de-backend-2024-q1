CREATE TABLE public.cliente (
	id SERIAL PRIMARY KEY,
	limite INTEGER NOT NULL
);

CREATE TABLE public.saldocliente (
	id INTEGER PRIMARY KEY NOT NULL,
	-- Dupliquei, é a vida.
	limite INTEGER NOT NULL,
  	saldo INTEGER NOT NULL,
    CONSTRAINT saldo_check CHECK (-(saldo) <= limite),
	CONSTRAINT fk_clientes_id
		FOREIGN KEY (id) REFERENCES cliente(id)
);

CREATE TABLE public.transacao (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL,
	CONSTRAINT fk_clientes_transacoes_id
		FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);


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
	