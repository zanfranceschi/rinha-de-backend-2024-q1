 -- Criar tabela clientes
    CREATE TABLE IF NOT EXISTS clientes (
        id SERIAL PRIMARY KEY,
        limite INT NOT NULL,
        saldo INT DEFAULT 0,
        nome VARCHAR(50) NOT NULL
    );
    
    
    -- Criar tabela transacoes
    CREATE TABLE IF NOT EXISTS transacoes (
        id SERIAL PRIMARY KEY,
        valor INT NOT NULL,
        tipo VARCHAR(1) NOT NULL,
        realizada_em TIMESTAMP NOT NULL DEFAULT NOW(),
        descricao VARCHAR(10) NOT NULL,
        cliente_id INT NOT NULL,
        FOREIGN KEY (cliente_id) REFERENCES clientes(id)
    );
    DO $$
    BEGIN
        INSERT INTO clientes (nome, limite)
        VALUES
            ('o barato sai caro', 1000 * 100),
            ('zan corp ltda', 800 * 100),
            ('les cruders', 10000 * 100),
            ('padaria joia de cocaia', 100000 * 100),
            ('kid mais', 5000 * 100);
        
    END;
    $$;
