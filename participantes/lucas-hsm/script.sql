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

create index clientes_index on clientes using hash (id);
create index transacoes_index on transacoes using hash (id_cliente);

CREATE OR REPLACE FUNCTION update_client(client_id int, val int, tipo char, descricao varchar(10), re timestamp with time zone)
RETURNS TABLE (
    new_limite int,
    new_saldo int
)
LANGUAGE plpgsql AS $$
DECLARE
    csaldo int;
    climite int;
BEGIN
    BEGIN
        SELECT saldo, limite INTO csaldo, climite FROM clientes WHERE id = client_id FOR UPDATE;

        IF (csaldo - val) < (climite * -1) THEN
            RETURN QUERY SELECT -1, -1;
            RETURN;
        END IF;

        UPDATE clientes SET saldo = (csaldo - val) WHERE id = client_id;

        INSERT INTO transacoes (id_cliente, tipo, descricao, realizada_em, valor)
        VALUES (client_id, tipo, descricao, re, ABS(val));
    END;
    RETURN QUERY SELECT climite, (csaldo - val);
    RETURN;
END;
$$;

CREATE TYPE Transacao AS (
       tipo char,
       descricao varchar(10),
       valor int,
       realizada_em TIMESTAMP WITH TIME ZONE
);

CREATE OR REPLACE FUNCTION get_client_and_transactions(client_id INT)
RETURNS TABLE (
    nlimite int,
    nsaldo int,
    ntipo char,
    ndescricao varchar(10),
    nvalor int,
    nrealizada_em TIMESTAMP WITH TIME ZONE
)
AS $$
DECLARE
    ntransacoes Transacao [];
    transacao record;
    c int;
BEGIN
    SELECT limite, saldo INTO nlimite, nsaldo FROM clientes WHERE id = client_id;
    SELECT COUNT(id_cliente) INTO c FROM transacoes where id_cliente = client_id;
    IF c < 1 then
        RETURN QUERY SELECT nlimite, nsaldo, ntipo, ndescricao, nvalor, nrealizada_em;
        RETURN;
    END IF;
    FOR transacao IN SELECT tipo, descricao, valor, realizada_em FROM transacoes where id_cliente = client_id ORDER BY realizada_em DESC LIMIT 10 LOOP
        RETURN QUERY SELECT nlimite, nsaldo, transacao.tipo, transacao.descricao, transacao.valor, transacao.realizada_em;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

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
