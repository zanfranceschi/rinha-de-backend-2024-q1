
CREATE TABLE IF NOT EXISTS Cliente (
  id SERIAL,
  limite INT NOT NULL,
  saldo INT NOT NULL
);

CREATE UNIQUE INDEX cliente_id_idx ON Cliente (id);

CREATE TABLE IF NOT EXISTS Transacao (
  id SERIAL,
  idCliente INT REFERENCES Cliente(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  valor INT NOT NULL,
  descricao VARCHAR(10) NOT NULL,
  tipo CHAR(1) NOT NULL,
  realizada_em VARCHAR(24)
);

CREATE INDEX transacao_idCliente_1_idx ON Transacao (idCliente) WITH (fillfactor = 30);
CREATE INDEX transacao_id_1_idx ON Transacao (id DESC) WITH (fillfactor = 30);

INSERT INTO Cliente (id, limite, saldo)
VALUES
  (1, 100000, 0),
  (2, 80000, 0),
  (3, 1000000, 0),
  (4, 10000000, 0),
  (5, 500000, 0);
