CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    limite INT NOT NULL,
    saldo INT NOT NULL DEFAULT 0
);


CREATE TABLE transacoes (
    id SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    valor INT NOT NULL,
    tipo CHAR(1) NOT NULL CHECK (tipo IN ('c', 'd')),
    descricao VARCHAR(10),
    realizada_em TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);


CREATE OR REPLACE FUNCTION atualizar_saldo(id_cliente INTEGER, valor INTEGER, tipo CHAR, descricao VARCHAR)
RETURNS TABLE (saldo INTEGER, limite INTEGER) AS $$
DECLARE
    novo_saldo INTEGER;
BEGIN
    -- Verifiar se cliente existe
    SELECT c.saldo, c.limite INTO saldo, limite FROM clientes c WHERE id = id_cliente;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'CLIENTE_NAO_ENCONTRADO';
    END IF;

    IF tipo = 'c' THEN
        saldo := saldo + valor;
        
    ELSIF tipo = 'd' THEN
        saldo := saldo - valor;

        -- Verificar se o saldo após a transação de débito é menor que o limite
        IF saldo < (-1 * limite) THEN
            RAISE EXCEPTION 'LIMITE_EXECEDIDO';
        END IF;
    END IF;

    novo_saldo := saldo;
    INSERT INTO transacoes (id_cliente, valor, tipo, descricao) VALUES (id_cliente, valor, tipo, descricao);
    UPDATE clientes SET saldo = novo_saldo WHERE id = id_cliente;

    RETURN NEXT;
    
    RETURN;
END;
$$ LANGUAGE plpgsql;


INSERT INTO 
    clientes (nome, limite)
VALUES
    ('o barato sai caro', 1000 * 100),
    ('zan corp ltda', 800 * 100),
    ('les cruders', 10000 * 100),
    ('padaria joia de cocaia', 100000 * 100),
    ('kid mais', 5000 * 100);