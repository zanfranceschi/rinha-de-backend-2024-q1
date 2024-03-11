
    DROP TABLE IF EXISTS cliente;
    CREATE UNLOGGED TABLE IF NOT EXISTS cliente (
        id SERIAL PRIMARY KEY NOT NULL,
        nome VARCHAR(50) NOT NULL,
        limite INTEGER NOT NULL,
        saldo INTEGER NOT NULL
    );

    DROP TABLE IF EXISTS transaction;
    CREATE UNLOGGED TABLE IF NOT EXISTS transaction (
        id SERIAL PRIMARY KEY NOT NULL,
        valor INTEGER NOT NULL,
        tipo CHAR(1) NOT NULL,
        descricao VARCHAR(10) NOT NULL,
        realizada_em TIMESTAMPTZ NOT NULL,
        cliente_id INTEGER NOT NULL
        );

    -- Inserção de valores iniciais na tabela clientes
    INSERT INTO cliente (nome, limite, saldo)
    VALUES
        ('Cliente1', 100000, 0),
        ('Cliente2', 80000, 0),
        ('Cliente3', 1000000, 0),
        ('Cliente4', 10000000, 0),
        ('Cliente5', 500000, 0);

    CREATE INDEX transacindex ON transaction (cliente_id);
    
    SELECT * FROM transaction;
    SELECT * FROM cliente;