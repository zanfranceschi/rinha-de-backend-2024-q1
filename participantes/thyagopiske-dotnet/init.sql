
create unlogged table if not exists Clientes (
	id serial primary key,
  	limite integer,
	saldo integer
);

create unlogged table if not exists Transacoes (
	id serial primary key,
	clienteId integer not null references Clientes(id),
	valor integer,
	tipo char not null,
	descricao varchar(10),
	realizadaEm timestamp
);

create index if not exists idx_transacoes_clienteId on Transacoes(clienteId);

insert into Clientes (limite, saldo) 
values
  (100000, 0),
  (80000, 0),
  (1000000, 0),
	(10000000, 0),
	(500000, 0);

create type meuTipo as (codigo integer, limite integer, saldo integer);

create or replace function criarTransacao(
	in clienteId integer,
	in valor integer,
	in tipo char,
	in descricao varchar(10)
) returns meuTipo as $$
	declare
		cliente clientes%rowtype;
		mt meuTipo;
		novoSaldo integer;
	begin 
		perform pg_advisory_xact_lock(clienteId);

		select * 
		into cliente
		from clientes
		where id = clienteId;
		
		if cliente.id is null then
			mt.codigo := -1;
			return mt;
		end if;

		if tipo = 'd' then
			novoSaldo := cliente.saldo - valor;
		else
			novoSaldo := cliente.saldo + valor;
		end if;

		if novoSaldo + cliente.limite < 0 then
			mt.codigo := -2;
			return mt;
		end if;

		insert into transacoes 
		(valor, tipo, descricao, clienteId, realizadaEm)
		values
		(valor, tipo, descricao, clienteId, now()::timestamp);

		update clientes
		set saldo = novoSaldo
		where id = clienteId;
		
		mt.codigo := 1;
		mt.limite := cliente.limite;
		mt.saldo := novoSaldo;
		
		return mt;
	end;
$$ language plpgsql;


create type saldotype as (
	total integer,
	dataExtrato timestamp,
	limite integer
);

create or replace function obterextrato(
	in idCliente integer
) returns json as $$
	declare
		cliente clientes%rowtype;
		saldo saldotype;
		ultimasTransacoes json[];
	begin

		select * 
		into cliente
		from clientes
		where id = idCliente;

		if cliente.id is null then
			return json_build_object(
				'codigo', -1
			);
		end if;

		saldo.total := cliente.saldo;
		saldo.dataExtrato := now()::timestamp;
		saldo.limite := cliente.limite;

		select array_agg(
			json_build_object(
			'valor', t.valor,
			'tipo', t.tipo,
			'descricao', t.descricao,
			'realizadaEm', t.realizadaEm
		) order by t.realizadaEm desc
		)
		into ultimasTransacoes
		from (
			select *
			from transacoes tr	
			where tr.clienteId = idCliente
			order by tr.realizadaEm desc
			limit 10 offset 0
		) as t;

    return json_build_object(
			'codigo', 1,
        'saldo', json_build_object(
            'total', saldo.total,
            'dataExtrato', saldo.dataExtrato,
            'limite', saldo.limite
        ),
        'ultimasTransacoes', ultimasTransacoes
    );
	end;
$$ language plpgsql;
