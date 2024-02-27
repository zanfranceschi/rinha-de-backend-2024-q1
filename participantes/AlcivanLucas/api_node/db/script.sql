-- Scripts para a criação dos clientes e transações
-- CREATE DATABASE IF NOT EXISTS rinha;
-- USE rinha;

-- CREATE TABLE IF NOT EXISTS clientes(
--     id SERIAL PRIMARY KEY ,
--     limite INTEGER NOT NULL,  -- deve ser o limite cadastrado do cliente. 
--     saldo INTEGER NOT NULL -- deve ser o novo saldo após a conclusão da transação.
-- );

-- CREATE TABLE IF NOT EXISTS transacoes(
--     id SERIAL PRIMARY KEY,
--     id_cliente INTEGER NOT NULL REFERENCES clientes, 
--     valor INTEGER NOT NULL, -- deve ser o valor da transação.
--     tipo CHAR(1) NOT NULL, -- deve ser c para crédito e d para débito.
--     descricao VARCHAR(10) NOT NULL,
--     realizada_em TIMESTAMP NOT NULL -- deve ser a data/hora da realização da transação.
-- );


-- CreateTable
CREATE TABLE "clientes" (
    "id" SERIAL NOT NULL,
    "limite" INTEGER NOT NULL,
    "saldo" INTEGER NOT NULL,

    CONSTRAINT "clientes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "transacoes" (
    "id" SERIAL NOT NULL,
    "cliente_id" INTEGER NOT NULL,
    "valor" INTEGER NOT NULL,
    "tipo" TEXT NOT NULL,
    "descricao" TEXT NOT NULL,
    "realizada_em" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "transacoes_pkey" PRIMARY KEY ("id")
);

INSERT INTO clientes (limite, saldo) VALUES (100000, 0);
INSERT INTO clientes (limite, saldo) VALUES (80000, 0);
INSERT INTO clientes (limite, saldo) VALUES (1000000, 0);
INSERT INTO clientes (limite, saldo) VALUES (10000000, 0);
INSERT INTO clientes (limite, saldo) VALUES (500000, 0);

-- DO $$
-- BEGIN
--   INSERT INTO clientes (nome, limite)
--   VALUES
--     ('o barato sai caro', 1000 * 100),
--     ('zan corp ltda', 800 * 100),
--     ('les cruders', 10000 * 100),
--     ('padaria joia de cocaia', 100000 * 100),
--     ('kid mais', 5000 * 100);
-- END; $$