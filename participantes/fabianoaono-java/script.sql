CREATE TABLE cliente (
  id BIGINT PRIMARY KEY,
  limite INTEGER,
  saldo INTEGER
);

CREATE TABLE transacao (
  id BIGINT PRIMARY KEY,
  cliente_id BIGINT NOT NULL,
  descricao VARCHAR(10) NOT NULL,
  tipo VARCHAR(1) NOT NULL,
  valor INTEGER NOT NULL,
  realizada_em TIMESTAMP NOT NULL,
  FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

CREATE SEQUENCE Cliente_SEQ START with 1 INCREMENT BY 50;
CREATE SEQUENCE Transacao_SEQ START with 1 INCREMENT BY 50;

INSERT INTO cliente (id, limite, saldo) VALUES
  (1, 1000   * 100, 0),
  (2, 800    * 100, 0),
  (3, 10000  * 100, 0),
  (4, 100000 * 100, 0),
  (5, 5000   * 100, 0);

