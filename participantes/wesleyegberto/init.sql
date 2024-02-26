DROP TABLE IF EXISTS public.clientes;
DROP TABLE IF EXISTS public.transacoes;

CREATE UNLOGGED TABLE clientes (
	id SERIAL NOT NULL,
	nome VARCHAR(50) NOT NULL,
	limite BIGINT NOT NULL,
	saldo BIGINT NOT NULL DEFAULT 0,
	CONSTRAINT clientes_pk PRIMARY KEY (id)
);

CREATE INDEX idx_cov_clientes ON clientes(id) INCLUDE (limite, saldo);

CREATE UNLOGGED TABLE public.transacoes (
	id SERIAL NOT NULL,
	id_cliente INT NOT NULL,
	realizada_em TIMESTAMP NOT NULL,
	tipo CHAR(1) NOT NULL,
	valor BIGINT NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	CONSTRAINT transacoes_pk PRIMARY KEY (id),
	CONSTRAINT tipo_permitido CHECK (tipo = 'c' OR tipo = 'd')
);

CREATE INDEX ultimas_transacoes_idx ON public.transacoes (id_cliente ASC, realizada_em DESC);

-- Clientes iniciais
INSERT INTO public.clientes (nome, limite)
VALUES
	('o barato sai caro', 1000 * 100),
	('zan corp ltda', 800 * 100),
	('les cruders', 10000 * 100),
	('padaria joia de cocaia', 100000 * 100),
	('kid mais', 5000 * 100);

