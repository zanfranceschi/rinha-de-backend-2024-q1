CREATE TABLE transacao (
    id SERIAL PRIMARY KEY,
    valor integer NOT NULL,
    tipo CHAR(1) not null,
    descricao varchar(10) NOT NULL,
    realizada_em timestamp NOT NULL DEFAULT (NOW() at time zone 'utc'),
    cliente_id integer NOT NULL
);

CREATE TABLE saldos (
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER NOT null unique,
	limite INTEGER NOT NULL,
	valor INTEGER NOT NULL
);

INSERT INTO saldos (cliente_id, limite, valor)
VALUES (1,   1000 * 100, 0),
	   (2,    800 * 100, 0),
	   (3,  10000 * 100, 0),
	   (4, 100000 * 100, 0),
	   (5,   5000 * 100, 0);