CREATE TABLE a ( -- account
  i INTEGER PRIMARY KEY, -- id
  s INTEGER NOT NULL, -- saldo
  l INTEGER NOT NULL -- limite
);
CREATE TABLE t ( -- transaction
  i SERIAL PRIMARY KEY, -- id
  a INTEGER NOT NULL, -- account_id
  v INTEGER NOT NULL, -- valor
  t CHAR(1) NOT NULL, -- tipo
  d VARCHAR(10) NOT NULL, -- descricao
  r TIMESTAMP NOT NULL DEFAULT NOW() -- realiza_em
  -- FOREIGN KEY(account_id) REFERENCES account(id)
);

INSERT INTO a (i, l, s) VALUES (1, 100000, 0);
INSERT INTO a (i, l, s) VALUES (2, 80000, 0);
INSERT INTO a (i, l, s) VALUES (3, 1000000, 0);
INSERT INTO a (i, l, s) VALUES (4, 10000000, 0);
INSERT INTO a (i, l, s) VALUES (5, 500000, 0);
