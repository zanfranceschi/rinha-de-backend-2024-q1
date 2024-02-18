create unlogged table if not exists contas (
    id serial primary key,
    limite integer not null,
    saldo integer not null,
    updated_at timestamptz
);

insert into contas (id, limite, saldo)
values (1, 100000, 0), (2, 80000, 0), (3, 1000000, 0), (4, 10000000, 0), (5, 500000, 0);

create unlogged table if not exists transacoes (
    id serial primary key,
    conta_id integer not null references contas(id),
    valor integer not null,
    descricao text not null,
    tipo text check (tipo in ('c', 'd')),
    realizada_em timestamp with time zone not null,
    foreign key (conta_id) references contas(id)
);

create index if not exists idx_transacoes_conta_id on transacoes(conta_id);

create or replace function process(
    conta_id integer,
    valor integer,
    descricao text,
    tipo text
)
returns JSON
language plpgsql as $$
begin
    -- locking
    perform saldo, limite from contas where id = conta_id for update;
    if tipo = 'd' then
        if (select saldo + limite from contas where id = conta_id) < valor then
            raise exception 'saldo insuficiente' using errcode = '23000';
        else
            update contas set saldo = saldo - valor, updated_at = now() where id = conta_id;
            insert into transacoes (conta_id, valor, descricao, tipo, realizada_em) values (conta_id, valor, descricao, tipo, now());
        end if;
    elsif tipo = 'c' then
        update contas set saldo = saldo + valor, updated_at = now() where id = conta_id;
        insert into transacoes (conta_id, valor, descricao, tipo, realizada_em) values (conta_id, valor, descricao, tipo, now());
    else
        raise exception 'tipo invalido' using errcode = '23000';
    end if;
    return (select json_build_object('limite', limite, 'saldo', saldo) from contas where id = conta_id);
end;
$$;

