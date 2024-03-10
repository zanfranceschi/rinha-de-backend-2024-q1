
create table transacoes (
    cliente_id int,
    valor numeric not null,
    descricao varchar(10) not null,
    tipo char(1) not null,
    data_hora_inclusao timestamp default NOW()
);
create table clientes (
    cliente_id int,
    nome varchar(100) not null,
    limite int not null,
    saldo int  not null

);

create index transacoes_idx_cliente_id on transacoes (cliente_id);
create index transacoes_idx_data_hora_inclusao on transacoes (data_hora_inclusao DESC);



INSERT INTO clientes VALUES
    (1, 'Cliente 1', 100000,0),
    (2, 'Cliente 2', 80000,0),
    (3, 'Cliente 3', 1000000,0),
    (4, 'Cliente 4', 10000000,0),
    (5, 'Cliente 5', 500000,0);



create or replace procedure do_trans(
    IN p_cliente_id int,
    IN p_tipo char,
    IN p_valor int,
    IN p_descricao text,
    out p_http_cod char(3),
    out p_saldo int,
    out p_limite int
)
    language plpgsql
as
$$
DECLARE
    v_count int;

begin
    SELECT saldo, limite
    into p_saldo, p_limite
    from clientes
    where cliente_id = p_cliente_id FOR UPDATE;

    if (p_tipo != 'c' AND p_tipo != 'd') then
        raise exception 'Tipo inválido!';
    end if;

    if p_tipo = 'c' then
        p_valor := p_valor * -1;
    end if;

    if p_tipo = 'd' and p_saldo - p_valor < (p_limite * -1) then
        p_http_cod := 422;
        raise exception using
            errcode = 'P0001',
            message = 'Sem limite!',
            hint = 'Tente um valor menor';
    end if;



    insert into transacoes(cliente_id, valor, descricao, tipo, data_hora_inclusao)
    values (p_cliente_id, abs(p_valor), p_descricao, p_tipo,  current_timestamp);

    update clientes
    set saldo = saldo - p_valor
    where cliente_id = p_cliente_id
    returning saldo, limite into p_saldo, p_limite;


    p_http_cod := 200;

exception
    when no_data_found then
        p_http_cod := 404;
    when not_null_violation then
        p_http_cod := 422;
    when sqlstate 'P0001' then
        p_http_cod := 422;
    when others then
        p_http_cod := 422;
        raise notice 'SQL error: % - %', SQLERRM, SQLSTATE;
end;
$$;

CREATE or replace PROCEDURE  DO_EXTRATO(
    IN p_cliente_id int,
    OUT p_http_cod char(3),
    OUT p_extrato text)
    language plpgsql
as
$$
DECLARE
    v_count  int := 0;
    v_result record;
BEGIN
    p_http_cod := '200';

    for v_result in SELECT  C.LIMITE AS LIMITE,
                            C.SALDO   AS SALDO,
                           VALOR,
                           DESCRICAO,
                           TIPO,
                           DATA_HORA_INCLUSAO
                    FROM clientes C
                             LEFT JOIN transacoes T ON T.CLIENTE_ID = C.CLIENTE_ID
                    WHERE C.CLIENTE_ID = p_cliente_id
                    ORDER BY T.DATA_HORA_INCLUSAO DESC
                    LIMIT 10
        loop

            if v_count = 0 then
                p_extrato := '{"saldo": {
                "total": ' || v_result.SALDO || ',
                "data_extrato": "' || current_timestamp || '",
                "limite": ' || v_result.LIMITE || '
              },"ultimas_transacoes": [';
            end if;
            if v_result.valor is not null then
                p_extrato := p_extrato || ' {
                  "valor": ' || v_result.valor || ',
                  "tipo": "' || v_result.tipo || '",
                  "descricao": "' || v_result.descricao || '",
                  "realizada_em": "' || v_result.data_hora_inclusao || '"
                },';
                v_count := v_count + 1;
            end if;


        end loop;
    if (v_count > 0) then
        p_extrato := trim(p_extrato, ',');
    end if;
    p_extrato := p_extrato || ']}';
    IF(p_extrato IS NULL) THEN
         raise exception no_data_found;
    end if;
exception
    when no_data_found then
        p_http_cod := 404;
    when not_null_violation then
        p_http_cod := 422;
    when sqlstate 'P0002' then
        p_http_cod := 422;
    when others then
        p_http_cod := 500;
        raise notice 'SQL error: % - %', SQLERRM, SQLSTATE;
END
$$