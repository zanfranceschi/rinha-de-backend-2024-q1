CREATE TABLE IF NOT EXISTS clientes (
	cliente_id BIGSERIAL PRIMARY KEY,
	nome VARCHAR(50),
	limite INT DEFAULT 0,
	saldo INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS transacoes (
	transacoes_id BIGSERIAL PRIMARY KEY,
	cliente_id INT,
	valor INT,
	tipo VARCHAR(1),
	descricao VARCHAR(10),
	realizada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

INSERT INTO clientes (nome, limite) VALUES
  	('o barato sai caro', 1000 * 100),
  	('zan corp ltda', 800 * 100),
  	('les cruders', 10000 * 100),
  	('padaria joia de cocaia', 100000 * 100),
  	('kid mais', 5000 * 100);

