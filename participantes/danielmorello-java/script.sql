CREATE TABLE tb_user (
    id INT PRIMARY KEY,
    limite BIGINT,
    saldo BIGINT
);

CREATE TABLE tb_transaction (
    id SERIAL PRIMARY KEY,
    cliente_id INT,
    valor BIGINT,
    tipo char(1),
    descricao varchar(10),
    realizada_em TIMESTAMP WITH TIME ZONE
);

INSERT INTO tb_user (id, limite, saldo) VALUES(1, 100000, 0);
INSERT INTO tb_user (id, limite, saldo) VALUES(2, 80000, 0);
INSERT INTO tb_user (id, limite, saldo) VALUES(3, 1000000, 0);
INSERT INTO tb_user (id, limite, saldo) VALUES(4, 10000000, 0);
INSERT INTO tb_user (id, limite, saldo) VALUES(5, 500000, 0);