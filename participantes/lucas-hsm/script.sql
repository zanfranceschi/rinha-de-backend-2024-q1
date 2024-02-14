CREATE TABLE clientes (
    id int,
    limite int,
    saldo int
);

create table transacoes (
    id_cliente int,
    tipo char,
    descricao varchar(10),
    realizada_em timestamp with time zone,
    valor int
);

create index clientes_index on clientes using hash(id);
create index transacoes_index on transacoes using hash(id_cliente);

create procedure update_client(i int, s int, t char, d varchar(10), r timestamp with time zone, v int)
       language SQL
       begin atomic
       update clientes set saldo = s where id = i;
       insert into transacoes values (i, t, d, r, v);
       end;

DO $$
BEGIN
  INSERT INTO clientes
  VALUES
    (1, 1000 * 100, 0),
    (2, 800 * 100, 0),
    (3, 10000 * 100, 0),
    (4, 100000 * 100, 0),
    (5, 5000 * 100, 0);
END; $$
