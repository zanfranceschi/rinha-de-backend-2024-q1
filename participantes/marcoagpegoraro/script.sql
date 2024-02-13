CREATE TABLE cliente (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(30) NOT NULL,
  limite INTEGER NOT NULL,
  saldo INTEGER NOT NULL
);

CREATE TABLE transacao (
    id SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL,
    tipo CHAR(1) NOT NULL,
    valor INTEGER NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizada_em VARCHAR(30) NOT NULL,
    CONSTRAINT fk_clientes_transacoes_id
        FOREIGN KEY (id_cliente) REFERENCES cliente(id)
);

CREATE INDEX IF NOT EXISTS idx_transacoes_id_desc ON cliente(id desc);
CREATE INDEX IF NOT EXISTS idx_transacoes_id_desc ON transacao(id desc);

INSERT INTO cliente (id, nome, limite, saldo) VALUES
	(1, 'o barato sai caro', 1000 * 100, 0),
	(2, 'zan corp ltda', 800 * 100, 0),
	(3, 'les cruders', 10000 * 100, 0),
	(4, 'padaria joia de cocaia', 100000 * 100, 0),
	(5, 'kid mais', 5000 * 100, 0);
