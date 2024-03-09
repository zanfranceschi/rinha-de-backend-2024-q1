CREATE TABLE IF NOT EXISTS clientes (
   id SERIAL PRIMARY KEY,
   nome VARCHAR(50),
   limite INT DEFAULT 0,
   saldo INT DEFAULT 0
);


CREATE TABLE IF NOT EXISTS transacoes (
   id SERIAL PRIMARY KEY,
   cliente_id INT,
   valor INT,
   tipo CHAR(1) CHECK (tipo IN ('d', 'c')),
   descricao VARCHAR(10),
   realizada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);


INSERT INTO clientes (nome, limite) VALUES
   ('o barato sai caro', 1000 * 100),
   ('zan corp ltda', 800 * 100),
   ('les cruders', 10000 * 100),
   ('padaria joia de cocaia', 100000 * 100),
   ('kid mais', 5000 * 100);
