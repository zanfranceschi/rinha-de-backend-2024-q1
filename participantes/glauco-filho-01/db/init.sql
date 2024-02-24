-- Define o esquema de busca padrão para 'public'
SET search_path = public;

-- Define a codificação do cliente para UTF-8
SET client_encoding = 'UTF8';

-- Define as opções de XML para conteúdo
SET xmloption = content;

-- Define o nível mínimo de mensagens do cliente
SET client_min_messages = warning;

-- Desativa a segurança de linha
-- SET row_security = off;

-- Cria a tabela 'clientes' no esquema 'public'
CREATE TABLE public.clientes (
    id SERIAL PRIMARY KEY,  -- Coluna para o ID do cliente, usando SERIAL para autoincremento
    nome VARCHAR(22) UNIQUE,  -- Coluna para o nome do cliente, com restrição de unicidade
    limite INTEGER,  -- Coluna para o limite de crédito do cliente
    montante INTEGER  -- Coluna para o montante do cliente
);

-- Cria a tabela 'transacoes' no esquema 'public'
CREATE TABLE public.transacoes (
    id SERIAL PRIMARY KEY,  -- Coluna para o ID da transação, usando SERIAL para autoincremento
    cliente_id INTEGER REFERENCES public.clientes(id),  -- Coluna para o ID do cliente, com restrição de chave estrangeira referenciando 'clientes'
    valor INTEGER,  -- Coluna para o valor da transação
    realizada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Coluna para a data e hora da transação, usando a data e hora atual como padrão
    descricao VARCHAR(10),  -- Coluna para a descrição da transação
    tipo CHAR(1)  -- Coluna para o tipo de transação ('c' para crédito, 'd' para débito)
);

-- Cria a função 'inserir_credito' para inserir uma transação de crédito
CREATE OR REPLACE FUNCTION inserir_credito(cliente_id INT, valor INT, descricao VARCHAR)
RETURNS TABLE(novo_montante INT, cliente_limite INT) AS $$
DECLARE
    var_novo_montante INT;
    var_cliente_limite INT;
BEGIN
    -- Verifica se o cliente existe
    IF NOT EXISTS (SELECT 1 FROM public.clientes WHERE id = cliente_id) THEN
        RAISE EXCEPTION 'NOUSER';
    END IF;

    -- Obtém um bloqueio exclusivo para o cliente
    PERFORM pg_advisory_xact_lock(cliente_id);

    -- Insere a transação de crédito
    INSERT INTO public.transacoes (cliente_id, valor, descricao, tipo)
    VALUES (cliente_id, valor, descricao, 'c');

    -- Atualiza o saldo do cliente e retorna montante e limite
    UPDATE public.clientes
    SET montante = montante + valor
    WHERE id = cliente_id
    RETURNING montante, limite INTO var_novo_montante, var_cliente_limite;

    -- Retorna os valores
    RETURN QUERY SELECT var_novo_montante, var_cliente_limite;
END;
$$ LANGUAGE plpgsql;

-- Cria a função 'inserir_debito' para inserir uma transação de débito
CREATE OR REPLACE FUNCTION inserir_debito(cliente_id INT, valor INT, descricao VARCHAR)
RETURNS TABLE(novo_montante INT, cliente_limite INT) AS $$
DECLARE
    var_novo_montante INT;
    var_cliente_limite INT;
BEGIN
    -- Verifica se o cliente existe
    IF NOT EXISTS (SELECT 1 FROM public.clientes WHERE id = cliente_id) THEN
        RAISE EXCEPTION 'NOUSER';
    END IF;

    -- Obtém um bloqueio exclusivo para o cliente
    PERFORM pg_advisory_xact_lock(cliente_id);

    -- Verifica se o cliente tem saldo suficiente
    IF NOT EXISTS (
        SELECT 1 FROM public.clientes
        WHERE id = cliente_id AND montante - valor >= -limite
    ) THEN
        RAISE EXCEPTION 'NOLIMIT';
    END IF;

    -- Insere a transação de débito
    INSERT INTO public.transacoes (cliente_id, valor, descricao, tipo)
    VALUES (cliente_id, valor, descricao, 'd'); -- Note o valor negativo

    -- Atualiza o saldo do cliente e retorna montante e limite
    UPDATE public.clientes
    SET montante = montante - valor
    WHERE id = cliente_id
    RETURNING montante, limite INTO var_novo_montante, var_cliente_limite;

    -- Retorna os valores
    RETURN QUERY SELECT var_novo_montante, var_cliente_limite;
END;
$$ LANGUAGE plpgsql;

-- Cria a função 'obter_ultimas_transacoes' para obter as últimas transações de um cliente
CREATE OR REPLACE FUNCTION obter_ultimas_transacoes(var_cliente_id INT)
RETURNS TABLE(valor INT, tipo CHAR, descricao VARCHAR, realizada_em TIMESTAMP, montante INT, limite INT) AS $$
BEGIN
    -- Verifica se o cliente existe
    IF NOT EXISTS (SELECT 1 FROM public.clientes WHERE id = var_cliente_id) THEN
        RAISE EXCEPTION 'NOUSER';
    END IF;

    -- Obtém um bloqueio exclusivo para o cliente
    PERFORM pg_advisory_xact_lock(var_cliente_id);

    -- Retorna as últimas transações do cliente
    RETURN QUERY 
    SELECT t.valor, t.tipo, t.descricao, t.realizada_em, c.montante, c.limite
    FROM public.transacoes t
    JOIN public.clientes c ON t.cliente_id = c.id
    WHERE t.cliente_id = var_cliente_id
    ORDER BY t.id DESC
    LIMIT 10;
END;
$$ LANGUAGE plpgsql;

-- Cria índices para otimizar consultas na tabela 'transacoes'
CREATE INDEX idx_transacoes_cliente_id ON public.transacoes(cliente_id);
CREATE INDEX idx_transacoes_realizada_em ON public.transacoes(realizada_em);

-- Insere dados iniciais na tabela 'clientes'
DO $$
BEGIN
  INSERT INTO public.clientes (nome, limite, montante)
  VALUES
    ('o barato sai caro', 1000 * 100, 0),
    ('zan corp ltda', 800 * 100, 0),
    ('les cruders', 10000 * 100, 0),
    ('padaria joia de cocaia', 100000 * 100, 0),
    ('kid mais', 5000 * 100, 0);
END; $$
