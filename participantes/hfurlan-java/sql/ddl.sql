create table transacoes (
    cliente_id int,
    valor int,
    descricao varchar(10),
    tipo char(1),
    data_hora_inclusao timestamp default NOW()
);

create table clientes (
    cliente_id int not null,
    nome varchar(100) not null,
    limite int not null constraint limite_positivo check (limite >= 0),
    saldo_inicial int not null constraint saldo_inicial_positivo check (saldo_inicial >= 0),
    primary key(cliente_id)
);

create unlogged table saldos (
    cliente_id int not null,
    saldo int not null constraint saldo_valido check (saldo >= (limite * -1)),
    limite int not null,
    transacao_0_valor int,
    transacao_0_tipo char(1),
    transacao_0_descricao varchar(10),
    transacao_0_data_hora_inclusao timestamp,
    transacao_1_valor int,
    transacao_1_tipo char(1),
    transacao_1_descricao varchar(10),
    transacao_1_data_hora_inclusao timestamp,
    transacao_2_valor int,
    transacao_2_tipo char(1),
    transacao_2_descricao varchar(10),
    transacao_2_data_hora_inclusao timestamp,
    transacao_3_valor int,
    transacao_3_tipo char(1),
    transacao_3_descricao varchar(10),
    transacao_3_data_hora_inclusao timestamp,
    transacao_4_valor int,
    transacao_4_tipo char(1),
    transacao_4_descricao varchar(10),
    transacao_4_data_hora_inclusao timestamp,
    transacao_5_valor int,
    transacao_5_tipo char(1),
    transacao_5_descricao varchar(10),
    transacao_5_data_hora_inclusao timestamp,
    transacao_6_valor int,
    transacao_6_tipo char(1),
    transacao_6_descricao varchar(10),
    transacao_6_data_hora_inclusao timestamp,
    transacao_7_valor int,
    transacao_7_tipo char(1),
    transacao_7_descricao varchar(10),
    transacao_7_data_hora_inclusao timestamp,
    transacao_8_valor int,
    transacao_8_tipo char(1),
    transacao_8_descricao varchar(10),
    transacao_8_data_hora_inclusao timestamp,
    transacao_9_valor int,
    transacao_9_tipo char(1),
    transacao_9_descricao varchar(10),
    transacao_9_data_hora_inclusao timestamp,
    primary key(cliente_id)
);

create or replace function inserir_saldo()
  returns TRIGGER 
  language PLPGSQL
  as
$$
begin
    insert into saldos (cliente_id, saldo, limite) values (NEW.cliente_id, NEW.saldo_inicial, NEW.limite);
    return NEW;
end;
$$;

create or replace function remover_saldo()
  returns TRIGGER 
  language PLPGSQL
  as
$$
begin
    delete from saldos where cliente_id = OLD.cliente_id;
    return OLD;
end;
$$;

create or replace trigger clientes_inserir_saldo
    after insert on clientes
    for each row
    execute function inserir_saldo();

create or replace trigger clientes_remover_saldo
    after delete ON clientes
    for each row
    execute function remover_saldo();

create function creditar(p_cliente_id int, p_valor int, p_descricao varchar(10)) RETURNS int AS $$
declare
  saldo_atualizado int;
begin
--with novo_saldo as (UPDATE saldos SET saldo = saldo + $1 WHERE cliente_id = $2 RETURNING saldo) insert into transacoes (cliente_id, valor, descricao, tipo, saldo) values ($3, $4, $5, $6, (select * from novo_saldo)) returning saldo
  insert into transacoes (cliente_id, valor, descricao, tipo) values (p_cliente_id, p_valor, p_descricao, 'c');
  update saldos set saldo = saldo + p_valor,
    transacao_0_valor = p_valor,
    transacao_0_tipo = 'c',
    transacao_0_descricao = p_descricao,
    transacao_0_data_hora_inclusao = NOW(),
    transacao_1_valor              = transacao_0_valor,
    transacao_1_tipo               = transacao_0_tipo,
    transacao_1_descricao          = transacao_0_descricao,
    transacao_1_data_hora_inclusao = transacao_0_data_hora_inclusao,
    transacao_2_valor              = transacao_1_valor,
    transacao_2_tipo               = transacao_1_tipo,
    transacao_2_descricao          = transacao_1_descricao,
    transacao_2_data_hora_inclusao = transacao_1_data_hora_inclusao,
    transacao_3_valor              = transacao_2_valor,
    transacao_3_tipo               = transacao_2_tipo,
    transacao_3_descricao          = transacao_2_descricao,
    transacao_3_data_hora_inclusao = transacao_2_data_hora_inclusao,
    transacao_4_valor              = transacao_3_valor,
    transacao_4_tipo               = transacao_3_tipo,
    transacao_4_descricao          = transacao_3_descricao,
    transacao_4_data_hora_inclusao = transacao_3_data_hora_inclusao,
    transacao_5_valor              = transacao_4_valor,
    transacao_5_tipo               = transacao_4_tipo,
    transacao_5_descricao          = transacao_4_descricao,
    transacao_5_data_hora_inclusao = transacao_4_data_hora_inclusao,
    transacao_6_valor              = transacao_5_valor,
    transacao_6_tipo               = transacao_5_tipo,
    transacao_6_descricao          = transacao_5_descricao,
    transacao_6_data_hora_inclusao = transacao_5_data_hora_inclusao,
    transacao_7_valor              = transacao_6_valor,
    transacao_7_tipo               = transacao_6_tipo,
    transacao_7_descricao          = transacao_6_descricao,
    transacao_7_data_hora_inclusao = transacao_6_data_hora_inclusao,
    transacao_8_valor              = transacao_7_valor,
    transacao_8_tipo               = transacao_7_tipo,
    transacao_8_descricao          = transacao_7_descricao,
    transacao_8_data_hora_inclusao = transacao_7_data_hora_inclusao,
    transacao_9_valor              = transacao_8_valor,
    transacao_9_tipo               = transacao_8_tipo,
    transacao_9_descricao          = transacao_8_descricao,
    transacao_9_data_hora_inclusao = transacao_8_data_hora_inclusao
    where cliente_id = p_cliente_id returning saldo into saldo_atualizado;
    return saldo_atualizado;
end;
$$ LANGUAGE plpgsql;

create function debitar(p_cliente_id int, p_valor int, p_descricao varchar(10)) RETURNS int AS $$
declare
  saldo_atualizado int;
begin
--with novo_saldo as (UPDATE saldos SET saldo = saldo + $1 WHERE cliente_id = $2 RETURNING saldo) insert into transacoes (cliente_id, valor, descricao, tipo, saldo) values ($3, $4, $5, $6, (select * from novo_saldo)) returning saldo
  insert into transacoes (cliente_id, valor, descricao, tipo) values (p_cliente_id, p_valor, p_descricao, 'd');
  update saldos set saldo = saldo - p_valor,
    transacao_0_valor = p_valor,
    transacao_0_tipo = 'd',
    transacao_0_descricao = p_descricao,
    transacao_0_data_hora_inclusao = NOW(),
    transacao_1_valor              = transacao_0_valor,
    transacao_1_tipo               = transacao_0_tipo,
    transacao_1_descricao          = transacao_0_descricao,
    transacao_1_data_hora_inclusao = transacao_0_data_hora_inclusao,
    transacao_2_valor              = transacao_1_valor,
    transacao_2_tipo               = transacao_1_tipo,
    transacao_2_descricao          = transacao_1_descricao,
    transacao_2_data_hora_inclusao = transacao_1_data_hora_inclusao,
    transacao_3_valor              = transacao_2_valor,
    transacao_3_tipo               = transacao_2_tipo,
    transacao_3_descricao          = transacao_2_descricao,
    transacao_3_data_hora_inclusao = transacao_2_data_hora_inclusao,
    transacao_4_valor              = transacao_3_valor,
    transacao_4_tipo               = transacao_3_tipo,
    transacao_4_descricao          = transacao_3_descricao,
    transacao_4_data_hora_inclusao = transacao_3_data_hora_inclusao,
    transacao_5_valor              = transacao_4_valor,
    transacao_5_tipo               = transacao_4_tipo,
    transacao_5_descricao          = transacao_4_descricao,
    transacao_5_data_hora_inclusao = transacao_4_data_hora_inclusao,
    transacao_6_valor              = transacao_5_valor,
    transacao_6_tipo               = transacao_5_tipo,
    transacao_6_descricao          = transacao_5_descricao,
    transacao_6_data_hora_inclusao = transacao_5_data_hora_inclusao,
    transacao_7_valor              = transacao_6_valor,
    transacao_7_tipo               = transacao_6_tipo,
    transacao_7_descricao          = transacao_6_descricao,
    transacao_7_data_hora_inclusao = transacao_6_data_hora_inclusao,
    transacao_8_valor              = transacao_7_valor,
    transacao_8_tipo               = transacao_7_tipo,
    transacao_8_descricao          = transacao_7_descricao,
    transacao_8_data_hora_inclusao = transacao_7_data_hora_inclusao,
    transacao_9_valor              = transacao_8_valor,
    transacao_9_tipo               = transacao_8_tipo,
    transacao_9_descricao          = transacao_8_descricao,
    transacao_9_data_hora_inclusao = transacao_8_data_hora_inclusao
    where cliente_id = p_cliente_id returning saldo into saldo_atualizado;
    return saldo_atualizado;
end;
$$ LANGUAGE plpgsql;
