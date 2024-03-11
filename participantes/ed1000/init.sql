DROP TABLE IF EXISTS transacoes;
--
DROP TABLE IF EXISTS clientes;

CREATE UNLOGGED TABLE IF NOT EXISTS clientes (
    id SERIAL NOT NULL,
    limite INTEGER NOT NULL,
	saldo INTEGER NOT NULL,
    PRIMARY KEY (id)
);

CREATE UNLOGGED TABLE IF NOT EXISTS transacoes (
    id SERIAL NOT NULL,
    id_clientes BIGINT NOT NULL,
    valor INTEGER NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10),
    realizada_em TIMESTAMP NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_clientes
        FOREIGN KEY(id_clientes)
        REFERENCES clientes(id)
);

DO $$
BEGIN
    INSERT INTO clientes (id, limite, saldo)
    VALUES
       (1, 1000 * 100, 0)
      ,(2, 800 * 100, 0)
      ,(3, 10000 * 100, 0)
      ,(4, 100000 * 100, 0)
      ,(5, 5000 * 100, 0);
END; $$
