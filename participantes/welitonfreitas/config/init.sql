--ALTER SYSTEM SET max_connections = 200;
CREATE TABLE if NOT EXISTS clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    limite INTEGER NOT NULL,
    saldo INTEGER NOT NULL
  );

CREATE TABLE if NOT EXISTS transacoes (
  id SERIAL PRIMARY KEY,
  valor INTEGER NOT NULL,
  descricao VARCHAR(100) NOT NULL,
  tipo VARCHAR(1) NOT NULL,
  realizada_em TIMESTAMP NOT NULL,
  cliente_id INTEGER NOT NULL REFERENCES clientes(id),
  FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE EXTENSION IF NOT EXISTS pg_prewarm;
SELECT pg_prewarm('clientes');
SELECT pg_prewarm( 'transacoes');

create or replace function altera_saldo_cliente(
  cliente_id integer, 
  valor integer
		) returns integer
    AS $$
  declare
    saldo_ integer;
    limite_ integer;
  begin
    select saldo, limite into saldo_, limite_ from clientes where id = cliente_id for update;
    if valor < 0 and abs(valor) >= sum(saldo_ + limite_) then
      raise exception 'Saldo negativo';
    end if;
    update clientes set saldo = saldo_ + valor where id = cliente_id;
    return sum(saldo_ + valor);

end; 
$$ LANGUAGE plpgsql;


DO $$
BEGIN
  
  INSERT INTO clientes (nome, limite, saldo)
  VALUES
    ('o barato sai caro', 1000 * 100, 0),
    ('zan corp ltda', 800 * 100, 0),
    ('les cruders', 10000 * 100, 0),
    ('padaria joia de cocaia', 100000 * 100, 0),
    ('kid mais', 5000 * 100, 0);
END; $$
