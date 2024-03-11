DO $$
BEGIN 
    CREATE TABLE IF NOT EXISTS clientes (
        id SERIAL PRIMARY KEY NOT NULL,
        nome VARCHAR(50) NOT NULL,
        limite INTEGER NOT NULL,
        saldo INTEGER NOT NULL
    );

    CREATE TABLE IF NOT EXISTS transacoes (
        id SERIAL PRIMARY KEY NOT NULL,
        tipo CHAR(1) NOT NULL,
        descricao VARCHAR(10) NOT NULL,
        valor INTEGER NOT NULL,
        cliente_id INTEGER NOT NULL,
        realizada_em TIMESTAMP NOT NULL DEFAULT NOW()
    );

    INSERT INTO clientes (nome, limite, saldo)
    VALUES
        ('Erick', 100000, 0),
        ('Vinicius', 80000, 0),
        ('Leonardo', 1000000, 0),
        ('Bob', 10000000, 0),
        ('Tom', 500000, 0);
END $$;