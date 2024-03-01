CREATE TABLE "clientes" (
    "id" SERIAL NOT NULL,
    "saldo" INTEGER NOT NULL,
    "limite" INTEGER NOT NULL,

    CONSTRAINT "cli_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "transacoes" (
    "id" SERIAL NOT NULL,
    "valor" INTEGER NOT NULL,
    "id_cliente" INTEGER NOT NULL,
    "tipo" CHAR NOT NULL,
    "descricao" VARCHAR(10) NOT NULL,
    "realizada_em" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "tra_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "tra_check1" CHECK (valor > 0),
    CONSTRAINT "tra_check2" CHECK (LENGTH(descricao) > 0),
    CONSTRAINT "tra_id_cliente_fkey" FOREIGN KEY ("id_cliente") REFERENCES "clientes" ("id")
);

CREATE INDEX tra_id_orderby ON transacoes (realizada_em DESC, id_cliente);

CREATE OR REPLACE FUNCTION debit(p_id INTEGER, p_value INTEGER, p_descricao VARCHAR) RETURNS SETOF clientes AS $$
DECLARE
    v_client clientes%ROWTYPE;
    v_new_balance NUMERIC;
BEGIN
    PERFORM pg_advisory_xact_lock(p_id);
    SELECT * INTO v_client FROM clientes WHERE id = p_id LIMIT 1;
    IF (v_client IS NULL) THEN
        RAISE EXCEPTION 'P0002';
    END IF;

    v_new_balance := v_client.saldo - p_value;
    IF (v_new_balance < (v_client.limite * -1)) THEN
        RAISE EXCEPTION '';
    END IF;

    INSERT INTO transacoes (id_cliente, valor, tipo, descricao) VALUES (p_id ,p_value, 'd', p_descricao );
    v_client.saldo := v_new_balance;
    UPDATE clientes SET saldo = v_new_balance WHERE id = p_id;
    RETURN NEXT v_client;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION credit(p_id INTEGER, p_value INTEGER, p_descricao VARCHAR) RETURNS SETOF clientes AS $$
DECLARE
    v_client clientes%ROWTYPE;
    v_new_balance NUMERIC;
BEGIN
    PERFORM pg_advisory_xact_lock(p_id);
    SELECT * INTO v_client FROM clientes WHERE id = p_id LIMIT 1;
    IF (v_client IS NULL) THEN
        RAISE EXCEPTION 'P0002';
    END IF;

    v_new_balance := v_client.saldo + p_value;
    INSERT INTO transacoes (id_cliente, valor, tipo, descricao) VALUES (p_id, p_value, 'c', p_descricao);
    v_client.saldo := v_new_balance;
    UPDATE clientes SET saldo = v_new_balance WHERE id = p_id;
    RETURN NEXT v_client;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION statement(p_id INTEGER) RETURNS JSONB AS $$
DECLARE
    v_saldo JSONB;
    v_transacoes JSONB;
BEGIN
    PERFORM pg_advisory_xact_lock(p_id);
    SELECT jsonb_build_object('total', saldo, 'data_extrato', CURRENT_TIMESTAMP(6), 'limite', limite ) INTO v_saldo FROM clientes WHERE id = p_id;
    IF (v_saldo IS NULL) THEN
        RAISE EXCEPTION 'P0002';
    END IF;

    SELECT COALESCE(jsonb_agg(
               jsonb_build_object(
                   'valor', valor,
                   'tipo', tipo,
                   'descricao', descricao,
                   'realizada_em', realizada_em
               )
           ), '[]'::JSONB)
    INTO v_transacoes FROM (
        SELECT valor, tipo, descricao, realizada_em FROM transacoes WHERE id_cliente = p_id ORDER BY realizada_em DESC LIMIT 10
    ) AS ultimas_transacoes;
    RETURN jsonb_build_object('saldo', v_saldo, 'ultimas_transacoes', v_transacoes);
END;
$$ LANGUAGE PLPGSQL;


DO $$
BEGIN
	INSERT INTO clientes (saldo, limite)
	VALUES
		(0, 100000),
		(0, 80000),
		(0, 1000000),
		(0, 10000000),
		(0, 500000);
END;
$$;