CREATE TABLE IF NOT EXISTS clientes (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
    limite INT DEFAULT 0 NOT NULL,
    saldo INT DEFAULT 0 NOT NULL
);

CREATE TABLE IF NOT EXISTS transacoes (
	id SERIAL PRIMARY KEY,
    id_cliente INT,
    valor INT DEFAULT 0 NOT NULL,
	tipo int NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP NOT NULL,
	CONSTRAINT fk_clientes_transacoes_id
		FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);


DO $$
BEGIN
INSERT INTO clientes (nome, limite)
VALUES
    ('diablo', 1000 * 100),
    ('baldurs gate', 800 * 100),
    ('world of warcraft', 10000 * 100),
    ('pokemon', 100000 * 100),
    ('magic', 5000 * 100);
END;
$$;