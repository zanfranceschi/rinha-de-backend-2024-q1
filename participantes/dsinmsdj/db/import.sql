CREATE UNLOGGED TABLE cliente (
	id_cliente SERIAL primary key,
    limite integer not null,
	saldo integer not null
);

CREATE UNLOGGED TABLE transacao (
	realizada_em timestamp not null default now(),
	id_cliente integer not null references cliente (id_cliente),
	valor integer not null,
	tipo char(1) not null,
	descricao varchar(10) not null
);

CREATE INDEX idx_realizos_em ON transacao (realizada_em);

INSERT INTO cliente (id_cliente, limite, saldo) VALUES
(1, 100000, 0),
(2, 80000, 0),
(3, 1000000, 0),
(4, 10000000, 0),
(5, 500000, 0);
