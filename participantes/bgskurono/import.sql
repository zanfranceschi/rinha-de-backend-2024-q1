CREATE TABLE clientes (
  id SERIAL PRIMARY KEY,
  nome VARCHAR (50) NOT NULL,
  limite INTEGER NOT NULL
);

CREATE TABLE transacoes (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    valor INTEGER NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_clientes_transacoes_id
        FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE INDEX idx_transacoes_id_desc ON transacoes(id desc);

CREATE TABLE saldos (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    valor INTEGER NOT NULL,
    CONSTRAINT fk_clientes_saldos_id
        FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE UNIQUE INDEX idx_saldos_cliente_id ON saldos (cliente_id) include (valor);

DO $$
BEGIN
    INSERT INTO clientes (nome, limite)
    VALUES
        ('cliente 1', 1000 * 100),
        ('cliente 2', 800 * 100),
        ('cliente 3', 10000 * 100),
        ('cliente 4', 100000 * 100),
        ('cliente 5', 5000 * 100);
    INSERT INTO saldos (cliente_id, valor)
        SELECT id, 0 FROM clientes;
END;
$$;


CREATE OR REPLACE FUNCTION credit(
    parametro_cliente_id INT,
    parametro_valor INT,
    parametro_tipo CHAR(1),
    parametro_descricao VARCHAR(10)
)
RETURNS INT AS $$
DECLARE
saldo_value INT;
BEGIN
    UPDATE saldos SET valor = valor + parametro_valor WHERE cliente_id = parametro_cliente_id
    RETURNING valor INTO saldo_value;

    INSERT INTO transacoes (cliente_id, valor, tipo, descricao, realizada_em)
    VALUES (parametro_cliente_id, parametro_valor, parametro_tipo, parametro_descricao, now());

    RETURN saldo_value;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION debit(
    parametro_cliente_id INT,
    parametro_limite INT,
    parametro_valor INT,
    parametro_tipo CHAR(1),
    parametro_descricao VARCHAR(10)
)
RETURNS INT AS $$
DECLARE
saldo_value INT;

BEGIN
    UPDATE saldos SET valor = valor - parametro_valor
    WHERE cliente_id = parametro_cliente_id AND valor - parametro_valor > parametro_limite
    RETURNING valor INTO saldo_value;

    IF saldo_value < parametro_limite THEN
       RETURN NULL;
    END IF;

    INSERT INTO transacoes (cliente_id, valor, tipo, descricao, realizada_em)
    VALUES (parametro_cliente_id, parametro_valor, parametro_tipo, parametro_descricao, now());

    RETURN saldo_value;
END;
$$ LANGUAGE plpgsql;
