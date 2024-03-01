create table transacoes (
    cliente_id int not null,
    valor numeric not null,
    descricao varchar(10) not null,
    tipo char(1) not null,
    saldo numeric not null,
    data_hora_inclusao timestamp default NOW()
);

create index transacoes_idx_cliente_id on transacoes (cliente_id);

create table clientes (
    cliente_id int not null,
    nome varchar(100) not null,
    limite numeric not null constraint limite_positivo check (limite >= 0),
    saldo_inicial numeric not null constraint saldo_inicial_positivo check (saldo_inicial >= 0),
    primary key(cliente_id)
);

create unlogged table saldos (
    cliente_id int not null,
    saldo numeric not null constraint saldo_valido check (saldo >= (limite * -1)),
    limite numeric not null,
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
