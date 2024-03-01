CREATE TABLE cliente (
	user_id SMALLINT PRIMARY KEY,
	limite INTEGER NOT NULL,
    saldo INTEGER NOT NULL
);

CREATE TABLE transacoes (
	id SERIAL PRIMARY KEY,
	user_id INTEGER NOT NULL,
	valor INTEGER NOT NULL,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_clientes_transacoes_id
		FOREIGN KEY (user_id) REFERENCES cliente(user_id)
);

DO $$
BEGIN
	INSERT INTO cliente (user_id, limite, saldo)
	VALUES
		(1, 100000, 0),
		(2, 80000, 0),
		(3, 1000000, 0),
		(4, 10000000, 0),
		(5, 500000, 0);
END;
$$;