CREATE TABLE IF NOT EXISTS clientes (
	id int2 NOT NULL,
	limite int8 DEFAULT 0 NOT NULL,
	saldo int8 DEFAULT 0 NOT NULL,
	CONSTRAINT clientes_pk PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS transacoes (
	id serial4 NOT NULL,
	valor int8 NOT NULL,
	descricao varchar NOT NULL,
	tipo bpchar(1) NOT NULL,
	realizada_em timestamptz DEFAULT now() NOT NULL,
	cliente_id int2 NOT NULL,
	CONSTRAINT transacoes_pk PRIMARY KEY (id)
);
CREATE INDEX transacoes_cliente_id_idx ON transacoes USING btree (cliente_id, realizada_em);

INSERT INTO clientes (id,limite,saldo) VALUES
	 (1,100000,0),
	 (2,80000,0),
	 (3,1000000,0),
	 (4,10000000,0),
	 (5,500000,0);
