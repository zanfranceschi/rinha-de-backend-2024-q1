CREATE UNLOGGED TABLE clientes (
    codigo int PRIMARY KEY,
    limite DECIMAL(10) NOT NULL,
    saldo DECIMAL(10) NOT NULL
);

CREATE UNLOGGED TABLE  transacoes (
    codigo SERIAL PRIMARY KEY,
    descricao VARCHAR(50) NOT NULL,
    data_transacao TIMESTAMP NOT NULL,
    tipo CHAR(1) CHECK (tipo IN ('d', 'c')),
    valor DECIMAL(10) NOT NULL,
    codigo_cliente INTEGER REFERENCES clientes(codigo) ON DELETE CASCADE
);

CREATE OR REPLACE FUNCTION realizar_transacao(
    p_codigo_cliente INTEGER,
    p_tipo CHAR(1),
    p_descricao VARCHAR(50),
    p_valor DECIMAL(10)
) RETURNS TABLE (novo_saldo DECIMAL(10), limite_cliente DECIMAL(10)) AS $$
DECLARE
    v_saldo_cliente DECIMAL(10);
    v_limite_cliente DECIMAL(10);
BEGIN
    -- Obtém o saldo e limite atuais do cliente
    SELECT saldo, limite 
      INTO v_saldo_cliente, v_limite_cliente 
      FROM clientes 
     WHERE codigo = p_codigo_cliente 
       FOR UPDATE ;

    -- Verifica se o cliente existe
    IF NOT FOUND THEN
        -- Cliente não encontrado, lança uma exceção
        RAISE EXCEPTION 'RN01:Cliente com código % não encontrado.', p_codigo_cliente;
    END IF;

   -- Valida se saldo e limite permitem transacao
   if p_tipo = 'd' then
   		if v_saldo_cliente - p_valor < (v_limite_cliente * -1) then
   			raise exception 'RN02:Saldo e limite não permitem transacao.';
   		end if;
   end if;
   
   
    -- Verifica o tipo de transação e realiza as operações necessárias
    IF p_tipo = 'd' THEN
        -- Transação de débito
        UPDATE clientes SET saldo = saldo - p_valor WHERE codigo = p_codigo_cliente;
    ELSIF p_tipo = 'c' THEN
        -- Transação de crédito
        UPDATE clientes SET saldo = saldo + p_valor WHERE codigo = p_codigo_cliente;
    ELSE
        -- Tipo de transação inválido
        RAISE EXCEPTION 'RN03:Tipo de transação inválido. Use "d" para débito ou "c" para crédito.';
    END IF;

    -- Insere a transação na tabela de transações
    INSERT INTO transacoes (descricao, data_transacao, tipo, valor, codigo_cliente)
         VALUES (p_descricao, CURRENT_TIMESTAMP, p_tipo, p_valor, p_codigo_cliente);

    -- Retorna o novo saldo e limite do cliente
    RETURN QUERY SELECT saldo, limite FROM clientes WHERE codigo = p_codigo_cliente;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION obter_saldo_e_transacoes(p_codigo_cliente INT)
RETURNS JSON
AS $$
DECLARE
    resultado JSON;
BEGIN
    -- Monta JSON com extrato do cliente
    SELECT json_build_object(
        'saldo', (SELECT * 
                    FROM json_build_object('total',c.saldo, 'data_extrato', current_timestamp, 'limite', c.limite)),
        'ultimas_transacoes', (SELECT COALESCE(json_agg(ut.*), '[]'::json)
                                 FROM (
                                       SELECT t.descricao, t.tipo, t.valor, t.data_transacao AS "realizada_em"
                                         FROM transacoes t 
                                        WHERE t.codigo_cliente = c.codigo
                                        ORDER BY t.data_transacao DESC 
                                        LIMIT 10) as ut)
    )
    into resultado    
    FROM clientes c
    WHERE c.codigo = p_codigo_cliente;
   
    -- Verifica se o cliente existe
    IF NOT FOUND THEN
        -- Cliente não encontrado, lança uma exceção
        RAISE EXCEPTION 'RN01:Cliente com código % não encontrado.', p_codigo_cliente;
    END IF;
   

    RETURN resultado;
END;
$$ LANGUAGE plpgsql;

INSERT INTO clientes (codigo, limite, saldo) VALUES 
(1, 100000, 0),
(2, 80000, 0),
(3, 1000000, 0),
(4, 10000000, 0),
(5, 500000, 0);
