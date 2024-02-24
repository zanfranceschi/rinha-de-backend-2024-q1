CREATE TABLE IF NOT EXISTS clientes (
  id INTEGER PRIMARY KEY AUTO_INCREMENT, 
  limite INTEGER NOT NULL,
  saldo INTEGER NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS transacoes (
  id INTEGER PRIMARY KEY AUTO_INCREMENT,
  cliente_id INTEGER,
  valor INTEGER NOT NULL,
  tipo ENUM('c', 'd') NOT NULL,
  descricao TEXT NOT NULL,
  realizada_em TIMESTAMP NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE transacoes add foreign key(cliente_id) references clientes(id);

INSERT INTO clientes(limite, saldo) VALUES (100000,0);
INSERT INTO clientes(limite, saldo) VALUES (80000,0);
INSERT INTO clientes(limite, saldo) VALUES (1000000,0);
INSERT INTO clientes(limite, saldo) VALUES (10000000,0);
INSERT INTO clientes(limite, saldo) VALUES (500000,0);