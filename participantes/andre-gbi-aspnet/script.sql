CREATE UNLOGGED TABLE clientes (
    id SERIAL PRIMARY KEY,
    limite DECIMAL(10) NOT NULL,
    saldo DECIMAL(10) NOT NULL
);

CREATE UNLOGGED TABLE transacoes (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER REFERENCES clientes(id) ON DELETE CASCADE,
    valor DECIMAL(10) NOT NULL,
    tipo CHAR(1) CHECK (tipo IN ('d', 'c')),
    descricao TEXT NOT NULL,
    realizada_em TIMESTAMP WITH TIME ZONE NOT NULL
);




CREATE FUNCTION maker_transacao(input_cliente_id INT, input_tipo VARCHAR, input_descricao VARCHAR, input_valor INT) 
RETURNS TABLE (saldo INT, limite_cliente INT, falha BOOLEAN, mensagem VARCHAR(40)) AS $$
DECLARE
    falha_result BOOLEAN := false;
    mensagem_result VARCHAR(40) := '';
    limite_search INT;
    saldo_search INT;
    valor_transacao_final INT;
BEGIN

        SELECT c.limite, c.saldo 
            INTO limite_search, saldo_search 
        FROM CLIENTES AS c 
            WHERE ID = input_cliente_id
        FOR UPDATE ;
        
      
        IF input_tipo = 'c' THEN

            mensagem_result := 'Sucesso no credito';
            valor_transacao_final :=  saldo_search + input_valor;
            UPDATE CLIENTES SET saldo = valor_transacao_final WHERE id = input_cliente_id;

        ELSE
        
             
            IF ABS(saldo_search) + input_valor > limite_search THEN

                mensagem_result := 'Cliente sem saldo';
                falha_result := true;
                
            ELSE
            
                mensagem_result := 'Sucesso no debito';
                valor_transacao_final :=  saldo_search - input_valor;
                UPDATE CLIENTES SET saldo = valor_transacao_final  WHERE id = input_cliente_id;
            
            END IF;

        END IF;
       


    IF falha_result = false THEN
        INSERT INTO transacoes (cliente_id,valor,tipo,descricao,realizada_em) VALUES (input_cliente_id,input_valor,input_tipo,input_descricao,NOW());
        RETURN QUERY SELECT valor_transacao_final, limite_search, falha_result, mensagem_result;
    ELSE
        RETURN QUERY SELECT 0, 0, falha_result, mensagem_result;

    END IF;

END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION proc_extrato(p_id INT)
RETURNS JSON AS $$
DECLARE
    saldo_info JSON;
BEGIN

    -- Construct and return the entire JSON in a single query
    SELECT JSON_BUILD_OBJECT(
        'saldo', (
            SELECT JSON_BUILD_OBJECT(
                'total', saldo,
                'limite', limite
            )
            FROM clientes
            WHERE id = p_id
        ),
        'ultimas_transacoes', (
            SELECT COALESCE(
                JSON_AGG(
                    JSON_BUILD_OBJECT(
                        'valor', valor,
                        'tipo', tipo,
                        'descricao', descricao,
                        'realizada_em', TO_CHAR(realizada_em, 'YYYY-MM-DD"T"HH24:MI:SS"Z"')
                    ) ORDER BY realizada_em DESC
                ), 
                '[]'::JSON
            )
            FROM (
                SELECT valor, tipo, descricao, realizada_em
                FROM transacoes
                WHERE cliente_id = p_id
                ORDER BY realizada_em DESC
                LIMIT 10
            ) AS ultimas_transacoes
        )
    ) INTO saldo_info;

    RETURN saldo_info;
END;
$$ LANGUAGE plpgsql;







INSERT INTO clientes (id, limite, saldo) VALUES 
(1, 100000, 0),
(2, 80000, 0),
(3, 1000000, 0),
(4, 10000000, 0),
(5, 500000, 0);
