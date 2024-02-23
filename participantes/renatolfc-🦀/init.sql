CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  limite INTEGER NOT NULL,
  saldo INTEGER NOT NULL,
  CHECK (saldo > -limite)
);

CREATE INDEX ON users (id);

INSERT INTO users(limite, saldo)
VALUES
  (100000, 0),
  (80000, 0),
  (1000000, 0),
  (10000000, 0),
  (500000, 0);
CREATE TYPE tipot AS ENUM ('C', 'D');
CREATE TABLE ledger (
  id SERIAL PRIMARY KEY,
  id_cliente INTEGER NOT NULL,
  valor INTEGER NOT NULL,
  tipo tipot NOT NULL,
  descricao VARCHAR(10) NOT NULL,
  realizada_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_cliente) REFERENCES users(id)
);

CREATE INDEX cliente_idx ON ledger(id_cliente);
CREATE INDEX realizada_idx ON ledger(realizada_em DESC);
CREATE PROCEDURE atualiza_livro_caixa(
  id_cliente INTEGER,
  valor INTEGER,
  valor_extrato INTEGER, 
  tipo tipot,
  descricao VARCHAR(10),
  OUT saldo_atual INTEGER,
  OUT limite_atual INTEGER
)
LANGUAGE plpgsql AS
$$
BEGIN
  INSERT INTO ledger (id_cliente, valor, tipo, descricao) VALUES (id_cliente, valor, tipo, descricao);
  UPDATE users
  SET saldo = saldo + valor_extrato
    WHERE id = id_cliente RETURNING saldo, limite INTO saldo_atual, limite_atual;
  COMMIT;
  RETURN;
END;
$$;
