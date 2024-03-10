CREATE SEQUENCE cliente_id_seq INCREMENT BY 50;
CREATE SEQUENCE transacao_id_seq INCREMENT BY 50;

CREATE TABLE IF NOT EXISTS cliente (
    id BIGINT DEFAULT nextval('cliente_id_seq'::regclass) PRIMARY KEY,
    nome VARCHAR(100),
    limite NUMERIC,
    saldo NUMERIC
);

CREATE TABLE if not exists transacao(
    id BIGINT DEFAULT nextval('transacao_id_seq'::regclass) PRIMARY KEY,
	valor  NUMERIC,
	tipo char,
	descricao varchar(10),
	external_id UUID,
	cliente_id bigint,
	realizada_em TIMESTAMP WITH TIME zone,
	FOREIGN KEY (cliente_id) REFERENCES cliente(id)

);

CREATE INDEX IF NOT EXISTS client_id_transacao_idx
ON transacao(cliente_id);

insert into cliente VALUES(1, '',100000, 0);
insert into cliente VALUES(2,'', 80000, 0);
insert into cliente VALUES(3, '',1000000, 0);
insert into cliente VALUES(4, '',10000000, 0);
insert into cliente VALUES(5,'', 500000, 0);