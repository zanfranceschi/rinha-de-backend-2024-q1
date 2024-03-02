delete from transacoes;
delete from clientes;

INSERT INTO clientes (id, saldo, limite)
VALUES 
    (1, 0, -100000),
    (2, 0, -80000),
    (3, 0, -1000000),
    (4, 0, -10000000),
    (5, 0, -500000);

CREATE OR REPLACE FUNCTION CriarTransacao(
    IN idcliente integer,
    IN tipo char(1),
    IN valor integer,
    IN descricao varchar(10),
    OUT status integer,
    OUT saldo_novo integer,
    OUT limite_novo integer
) AS $$
DECLARE
    cliente_record clientes%rowtype;    
  valor_com_sinal integer;
BEGIN
    SELECT * FROM clientes INTO cliente_record WHERE id = idcliente;

    IF not found THEN --cliente não encontrado
        status := -1;
        saldo_novo := 0;
        limite_novo := 0;
        RETURN;
    END IF;
    raise notice'Criando transacao para cliente %.', idcliente;
    INSERT INTO transacoes (tipo, valor, descricao, realizada_em, idcliente)
    VALUES (tipo, valor, descricao, CURRENT_TIMESTAMP, idcliente);

    select valor * (case when tipo = 'd' then -1 else 1 end) into valor_com_sinal;    

    UPDATE clientes
    SET saldo = saldo + valor_com_sinal
    WHERE id = idcliente AND (valor_com_sinal > 0 OR saldo + valor_com_sinal >= limite)
    RETURNING saldo, -limite INTO saldo_novo, limite_novo;
  
    IF limite_novo IS NULL THEN --sem limite
        status := -2;
        saldo_novo := 0;
        limite_novo := 0;
        RETURN;
    END IF;
  
    status := 0;
END;$$ LANGUAGE plpgsql;
/*
select CriarTransacao(1, 'c', 1000, 'teste')
union all
select CriarTransacao(6, 'c', 1000, 'teste')
union all
select CriarTransacao(1, 'd', 10000000, 'teste');
*/