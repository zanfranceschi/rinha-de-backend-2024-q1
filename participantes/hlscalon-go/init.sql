
CREATE UNLOGGED TABLE cliente (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	limite INTEGER NOT NULL DEFAULT 0,
	saldo INTEGER NOT NULL DEFAULT 0
);

-- Verificar índices cliente

CREATE UNLOGGED TABLE transacao (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT NULL,
	valor INTEGER NOT NULL DEFAULT 0,
	tipo CHAR(1) NOT NULL,
	descricao VARCHAR(10) NOT NULL,
	realizada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	limite_atual INTEGER, -- somente para performance no retorno
	saldo_atual INTEGER -- somente para performance no retorno
);

CREATE INDEX idx_transacao_cliente_id ON transacao (cliente_id);

INSERT INTO cliente (nome, limite)
VALUES
	('o barato sai caro', 1000 * 100),
	('zan corp ltda', 800 * 100),
	('les cruders', 10000 * 100),
	('padaria joia de cocaia', 100000 * 100),
	('kid mais', 5000 * 100);

-- Insere valores iniciais
INSERT INTO transacao (cliente_id, valor, tipo, descricao, limite_atual, saldo_atual)
  SELECT id, 0, 'i', 'inicial', limite, saldo
  FROM cliente;
  
