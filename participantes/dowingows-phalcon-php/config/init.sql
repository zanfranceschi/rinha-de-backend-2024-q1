CREATE UNLOGGED TABLE clientes (
    id SERIAL PRIMARY KEY,
    limite INT,
    saldo INT
);

CREATE UNLOGGED TABLE transacoes (
    id SERIAL PRIMARY KEY,
    valor INT,
    tipo CHAR(1),
    cliente_id INT,
    descricao VARCHAR(10),
    realizada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_cliente_e_suas_transacoes ON transacoes (cliente_id, realizada_em DESC);

INSERT INTO clientes (limite, saldo) VALUES
(100000, 0),
(80000, 0),
(1000000, 0),
(10000000, 0),
(500000, 0);


CREATE OR REPLACE FUNCTION realizar_transacao(
    IN p_cliente_id INT,
    IN p_valor INT,
    IN p_descricao VARCHAR(10),
    IN p_tipo CHAR(1)
)
RETURNS RECORD AS $$
DECLARE
    v_saldo_atual INT;
    v_limite INT;
    ret RECORD;
BEGIN

    SELECT saldo, limite INTO v_saldo_atual, v_limite
    FROM clientes
    WHERE id = p_cliente_id
    FOR UPDATE; 

    IF p_tipo = 'd' THEN
        IF (v_saldo_atual - p_valor) < (-v_limite) THEN
            RAISE EXCEPTION 'Limite disponível atingido!';
        ELSE
            UPDATE clientes
            SET saldo = saldo - p_valor
            WHERE id = p_cliente_id 
            RETURNING saldo, limite INTO ret;

            INSERT INTO transacoes (valor, tipo, cliente_id, descricao)
            VALUES (p_valor, 'd', p_cliente_id, p_descricao);
        END IF;
    ELSIF p_tipo = 'c' THEN
        UPDATE clientes
        SET saldo = saldo + p_valor
        WHERE id = p_cliente_id
        RETURNING saldo, limite INTO ret;

        INSERT INTO transacoes (valor, tipo, cliente_id, descricao)
        VALUES (p_valor, 'c', p_cliente_id, p_descricao);
    ELSE
        RAISE EXCEPTION 'Transação inválida!';
    END IF;

    RETURN ret;
END;
$$ LANGUAGE plpgsql;
