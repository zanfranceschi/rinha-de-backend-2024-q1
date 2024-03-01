ALTER SYSTEM SET max_connections TO '300';

CREATE UNLOGGED TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    limite INTEGER NOT NULL,
    saldo_atual integer not null default 0,
    versao integer not null default 0
);

CREATE UNLOGGED TABLE transacoes (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    valor INTEGER NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP NOT NULL DEFAULT NOW(),
    versao integer not null,
    CONSTRAINT fk_clientes_transacoes_id
        FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE UNIQUE INDEX uk_clientes_transacoes_versao ON transacoes (cliente_id,versao);

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

CREATE or replace FUNCTION efetuar_transacao(
    in in_descricao varchar(10), 
    in in_valor int, 
    in in_tipo char(1),
    in in_client_id int,
    out out_operation_status int,
    out out_saldo_atual int,
    out out_limite int) 
AS $$
declare versao_antiga int;
        novo_saldo int;
        atualizados int;
begin
/*
*   Operation status
*   1= Sucesso
*   2= Saldo Insuficiente
*   3= Conflito
*/    
    -- Resgata saldo atual
    select saldo_atual 
         , versao 
         , limite
    from clientes
    where id = in_client_id
    into out_saldo_atual, 
         versao_antiga, 
         out_limite;     

    -- Atualiza saldo do cliente
    novo_saldo := out_saldo_atual - in_valor;
    if in_tipo = 'c' then
        novo_saldo := out_saldo_atual + in_valor;
    end if;
    
    if (out_limite * -1) > novo_saldo then
        out_operation_status := 2;
        return;  
    end if;

    update clientes set 
          saldo_atual = novo_saldo
        , versao = versao_antiga + 1
    where id = in_client_id
      and versao = versao_antiga;

    -- Confirma sucesso da atualização de saldo
    GET DIAGNOSTICS atualizados = ROW_COUNT;   
    if atualizados = 0 then
        out_operation_status := 3; 
        return;
    end if;
     
    -- Registra transação 
    INSERT INTO transacoes (
          cliente_id
        , valor
        , tipo
        , descricao
        , realizada_em
        , versao
    ) VALUES(
          in_client_id
        , in_valor
        , in_tipo
        , in_descricao
        , now()
        , versao_antiga + 1
    );

    out_saldo_atual := novo_saldo;     
    out_operation_status := 1;    
END;
$$ LANGUAGE plpgsql;
