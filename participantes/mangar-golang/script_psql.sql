CREATE TABLE IF NOT EXISTS clientes
(
    id          int not null Primary key,
    limite      int not null default 0,
    saldo       int not null default 0
);


insert into clientes (id, limite, saldo) values(1, 100000, 0);
insert into clientes (id, limite, saldo) values(2, 80000, 0);
insert into clientes (id, limite, saldo) values(3, 1000000, 0);
insert into clientes (id, limite, saldo) values(4, 10000000, 0);
insert into clientes (id, limite, saldo) values(5, 500000, 0);

CREATE UNLOGGED TABLE IF NOT EXISTS transacoes
(
    id           varchar(100) not null,
    id_cliente   INT NOT NULL,
    valor        INT NOT NULL,
    tipo         VARCHAR(1) NOT NULL,
    descricao    VARCHAR(100) NOT NULL,
    ultimo_saldo INT,
    created_at   TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

ALTER TABLE transacoes SET (autovacuum_enabled = false);


-- 
-- credito
-- 
CREATE OR REPLACE FUNCTION func_credito(
    pid VARCHAR(30),
    pid_cliente INT,
    pvalor INT,
    pdescricao VARCHAR(10),
    pcreated_at TIMESTAMPTZ
)
RETURNS TABLE (saldo_atual INT, limite_atual INT)
LANGUAGE plpgsql
AS $$
DECLARE
    var_saldo INT;
BEGIN
    LOCK TABLE clientes, transacoes IN ACCESS EXCLUSIVE MODE;

    INSERT INTO transacoes (id, id_cliente, valor, tipo, descricao, ultimo_saldo, created_at)
    VALUES (pid, pid_cliente, pvalor, 'c', pdescricao, var_saldo, pcreated_at);

    RETURN QUERY
        UPDATE clientes SET saldo = saldo + pvalor WHERE id = pid_cliente
        RETURNING saldo, limite;
END;
$$;



-- 
-- debito
-- 
CREATE OR REPLACE FUNCTION func_debito(
    pid VARCHAR(30),
    pid_cliente INT,
    pvalor INT,
    pdescricao VARCHAR(10),
    pcreated_at TIMESTAMPTZ
)
RETURNS TABLE (saldo_atual INT, limite_atual INT) 
LANGUAGE plpgsql 
AS $$
DECLARE
    var_saldo INT;
    var_limite INT;
BEGIN
    LOCK TABLE clientes, transacoes IN ACCESS EXCLUSIVE MODE;

    SELECT c.saldo, c.limite 
    INTO var_saldo, var_limite
    FROM clientes c
    WHERE c.id = pid_cliente;

    IF (var_saldo - pvalor >= -var_limite) THEN


        INSERT INTO transacoes (id, id_cliente, valor, tipo, descricao, ultimo_saldo, created_at)
        VALUES (pid, pid_cliente, pvalor, 'd', pdescricao, var_saldo, pcreated_at);

        UPDATE clientes SET saldo = var_saldo WHERE id = pid_cliente;

        RETURN QUERY 
            UPDATE clientes SET saldo = saldo - pvalor WHERE id = pid_cliente
            RETURNING saldo, limite;

    ELSE
        RAISE EXCEPTION '[001] Cliente não tem limite para a operação';
    END IF;
END;
$$;

