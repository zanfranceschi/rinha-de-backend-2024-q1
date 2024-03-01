CREATE UNLOGGED TABLE clientes (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
  saldo INTEGER NOT NULL,
	limite INTEGER NOT NULL,
  CONSTRAINT ck_saldo CHECK ( clientes.saldo > (clientes.limite * -1))
);

CREATE UNLOGGED TABLE transacoes (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_clientes_transacoes_id
		FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

INSERT INTO clientes (nome, saldo, limite)
VALUES
  ('Cliente 01', 0, 1000 * 100),
  ('Cliente 02', 0, 800 * 100),
  ('Cliente 03', 0, 10000 * 100),
  ('Cliente 04', 0, 100000 * 100),
  ('Cliente 05', 0, 5000 * 100);
