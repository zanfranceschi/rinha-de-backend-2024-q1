CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    limite INTEGER NOT NULL
);

CREATE TABLE transacoes (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    valor INTEGER NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_clientes_transacoes_id
        FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TABLE saldos (
   id SERIAL PRIMARY KEY,
   cliente_id INTEGER NOT NULL,
   valor INTEGER NOT NULL,
   CONSTRAINT fk_clientes_saldos_id
       FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);


CREATE INDEX idx_clientes_id ON clientes (id);
CREATE INDEX idx_transacoes_cliente_id ON transacoes (cliente_id);
CREATE INDEX idx_saldos_cliente_id ON saldos (cliente_id);

BEGIN TRANSACTION;

INSERT INTO clientes (nome, limite)
VALUES
    ('o barato sai caro', 1000 * 100),
    ('zan corp ltda', 800 * 100),
    ('les cruders', 10000 * 100),
    ('padaria joia de cocaia', 100000 * 100),
    ('kid mais', 5000 * 100);

INSERT INTO saldos (cliente_id, valor)
SELECT id, 0 FROM clientes;

CREATE OR REPLACE FUNCTION atualizar_saldo_transacao(
    cliente_id_param INTEGER,
    valor_transacao_param INTEGER,
    tipo_transacao_param CHAR(1),
    descricao_transacao_param VARCHAR(10) 
) RETURNS TABLE(success BOOLEAN, new_saldo INTEGER) AS
$$
DECLARE
    limite_cliente INTEGER;
    saldo_valor INTEGER;
    novo_saldo INTEGER;
    descricao VARCHAR(10);
BEGIN
    -- Obter o limite do cliente
    SELECT limite INTO limite_cliente FROM clientes WHERE id = cliente_id_param; -- FOR UPDATE --POSSO ALTERAR ISSO PQ ELE NÃO PRECISA CONSULTAR ISSO
    
    -- Obter o saldo atual do cliente
    SELECT valor INTO saldo_valor FROM saldos WHERE cliente_id = cliente_id_param FOR UPDATE; -- FOR UPDATE
    
    -- Calcular o novo saldo com base no tipo de transação
    IF tipo_transacao_param = 'c' THEN
        novo_saldo := saldo_valor + valor_transacao_param;
    ELSE
        novo_saldo := saldo_valor - valor_transacao_param;
    END IF;
    
    -- Verificar se o novo saldo ultrapassa o limite
    IF (limite_cliente + novo_saldo) < 0 THEN
        -- Se sim, fazer rollback e retornar false
        RETURN QUERY SELECT false, null::INTEGER;
    ELSE
        -- Se não, atualizar o saldo do cliente e inserir a transação
        UPDATE saldos SET valor = novo_saldo WHERE cliente_id = cliente_id_param;
        
        INSERT INTO transacoes (cliente_id, valor, tipo, descricao) 
        VALUES (cliente_id_param, valor_transacao_param, tipo_transacao_param, descricao_transacao_param);

        -- Se bem-sucedido, retornar true e o novo saldo
        RETURN QUERY SELECT true, novo_saldo;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        -- Em caso de erro, fazer rollback e retornar false
        RETURN QUERY SELECT false, null::INTEGER;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ObterSaldoETransacoes(clienteId integer)
RETURNS TABLE (saldo integer, ultimas_transacoes jsonb)
AS $$
DECLARE
    saldo_result integer;
    transacoes_result jsonb;
BEGIN
    -- Consulta de Saldo
    SELECT valor INTO saldo_result FROM saldos WHERE cliente_id = clienteId; -- FOR UPDATE

    SELECT jsonb_agg(jsonb_build_object('valor', t.valor, 'tipo', t.tipo, 'descricao', t.descricao, 'realizada_em', t.realizada_em))
INTO transacoes_result
FROM (
    SELECT valor, tipo, descricao, realizada_em
    FROM transacoes
    WHERE cliente_id = clienteId
    ORDER BY realizada_em DESC
    LIMIT 10
) t;

    -- Retornar os resultados
    RETURN QUERY SELECT saldo_result, transacoes_result;
END;
$$
LANGUAGE plpgsql;

COMMIT;
