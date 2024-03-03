ALTER SYSTEM SET max_connections              = '200';
ALTER SYSTEM SET shared_buffers               = '50MB';
ALTER SYSTEM SET effective_cache_size         = '150MB';
ALTER SYSTEM SET maintenance_work_mem         = '12800kB';
ALTER SYSTEM SET checkpoint_completion_target = '0.9';
ALTER SYSTEM SET wal_buffers                  = '1536kB';
ALTER SYSTEM SET default_statistics_target    = '100';
ALTER SYSTEM SET random_page_cost             = '4';
ALTER SYSTEM SET effective_io_concurrency     = '2';
ALTER SYSTEM SET work_mem                     = '128kB';
ALTER SYSTEM SET huge_pages                   = 'off';
ALTER SYSTEM SET min_wal_size                 = '1GB';
ALTER SYSTEM SET max_wal_size                 = '4GB';

CREATE TABLE cliente (
	id                           BIGINT                    NOT NULL,
	limite                       BIGINT      DEFAULT 0     NOT NULL,
	saldo                        BIGINT                    NOT NULL,
	CONSTRAINT cliente_pk        PRIMARY KEY (id),
	CONSTRAINT cliente_limite_ck CHECK       ((saldo + limite) > -1)
);

CREATE TABLE transacao (
	id                           BIGINT      GENERATED ALWAYS AS IDENTITY,
	valor                        BIGINT                    NOT NULL,
	tipo                         VARCHAR(10)               NOT NULL,
	descricao                    VARCHAR(10)               NOT NULL,
	realizada_em                 TIMESTAMPTZ DEFAULT NOW() NOT NULL,
	cliente_id                   BIGINT                    NOT NULL,
    CONSTRAINT transacao_pk      PRIMARY KEY (id),
    CONSTRAINT cliente_fk        FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

CREATE INDEX CONCURRENTLY idx_transacao_01 ON transacao (
    cliente_id,
    id         DESC
);

CREATE OR REPLACE PROCEDURE nova_transacao (
	IN    cliente_id              BIGINT,
	IN    transacao_tipo          VARCHAR(10),
	IN    transacao_valor         BIGINT,
	IN    transacao_descricao     VARCHAR(10),
	INOUT resultado               VARCHAR(30),
	INOUT cliente_saldo           BIGINT,
	INOUT cliente_limite          BIGINT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE cliente
    SET saldo = (
        CASE transacao_tipo
        WHEN 'DEBIT'  THEN saldo - transacao_valor
        WHEN 'CREDIT' THEN saldo + transacao_valor
        END
    )
    WHERE id = cliente_id
    RETURNING
        saldo,
        limite
    INTO
        cliente_saldo,
        cliente_limite;

	IF NOT FOUND THEN
		resultado := 'CLIENTE_NAO_ENCONTRADO';
		RETURN;
    END IF;

	resultado := 'SUCESSO';
    INSERT INTO transacao (
        tipo,
        valor,
        descricao,
        cliente_id
    )
    VALUES (
        transacao_tipo,
        transacao_valor,
        transacao_descricao,
        cliente_id
    );

    EXCEPTION
        WHEN SQLSTATE '23514' THEN
            resultado := 'CLIENTE_LIMITE_EXCEDIDO';
END;
$$;

INSERT INTO cliente
VALUES
    (1, 100000, 0),
	(2, 80000, 0),
	(3, 1000000, 0),
	(4, 10000000, 0),
	(5, 500000, 0);
