CREATE UNLOGGED TABLE IF NOT EXISTS "clientes" (
	"id" SERIAL NOT NULL PRIMARY KEY,
	"limite" INTEGER NOT NULL,
	"saldo" BIGINT NOT NULL DEFAULT 0
);

CREATE UNLOGGED TABLE IF NOT EXISTS "transacoes" (
	"id" SERIAL NOT NULL PRIMARY KEY,
	"cliente_id" INTEGER NOT NULL,
	"tipo" CHARACTER(1) NOT NULL,
	"valor" BIGINT NOT NULL,
	"descricao" VARCHAR(10) NOT NULL,
	"realizada_em" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT "fk_clientes_transacoes_id" FOREIGN KEY ("cliente_id") REFERENCES clientes ("id")
);

CREATE INDEX "fk_transacoes_cliente_id" ON "public"."transacoes" ("cliente_id");


INSERT INTO
	clientes ("limite", "saldo")
VALUES
	(1000 * 100, 0),
	(800 * 100, 0),
	(10000 * 100, 0),
	(100000 * 100, 0),
	(5000 * 100, 0);

END;

CREATE OR REPLACE FUNCTION transacao(
    _cliente_id INTEGER,
    _valor INTEGER,
    _tipo CHAR,
    _descricao VARCHAR(10),
    OUT codigo_erro SMALLINT,
    OUT out_limite INTEGER,
	OUT out_saldo BIGINT
)
RETURNS record AS
$$
BEGIN
        IF _tipo = 'c' THEN
            UPDATE clientes 
            SET saldo = saldo + _valor 
            WHERE id = _cliente_id 
            RETURNING limite, saldo INTO out_limite, out_saldo;
            INSERT INTO transacoes(cliente_id, valor, tipo, descricao)
            VALUES (_cliente_id, _valor, _tipo, _descricao);
            codigo_erro := 0;
            RETURN;
        ELSIF _tipo = 'd' THEN
            UPDATE clientes
            SET saldo = saldo - _valor
            WHERE id = _cliente_id AND saldo - _valor > -limite
            RETURNING limite, saldo INTO out_limite, out_saldo;
            
            IF FOUND THEN 
              INSERT INTO transacoes(cliente_id, valor, tipo, descricao)
              VALUES (_cliente_id, _valor, _tipo, _descricao);
              codigo_erro := 0;
            ELSE 
              codigo_erro := 2;
            END IF;

            RETURN;
        ELSE
            codigo_erro := 3;
            RETURN;
        END IF;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION extrato(
    _cliente_id INTEGER
)
RETURNS table (
	cliente_limite INTEGER,
	cliente_saldo BIGINT,
	id int,
	cliente_id INTEGER,
	tipo CHARACTER,
	valor BIGINT,
	descricao VARCHAR(10),
	realizada_em TIMESTAMP
	) 
	AS
$$
BEGIN
		RETURN QUERY
		SELECT c.limite as "cliente_limite", c.saldo as "cliente_saldo", t.*
		FROM clientes as c
		LEFT JOIN transacoes as t ON c.id = t.cliente_id
		WHERE c.id = _cliente_id
		ORDER BY t.realizada_em DESC
		LIMIT 10;
END;
$$
LANGUAGE plpgsql;
