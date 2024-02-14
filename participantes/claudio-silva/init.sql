CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE TABLE IF NOT EXISTS clientes (
                                        id SERIAL PRIMARY KEY NOT NULL,
                                        nome VARCHAR(100) NOT NULL,
                                        limite int DEFAULT 0,
                                        saldo int DEFAULT 0
);

CREATE INDEX IF NOT EXISTS clientes_id ON clientes (id);


INSERT INTO clientes (nome, limite)
VALUES
    ('o barato sai caro', 1000 * 100),
    ('zan corp ltda', 800 * 100),
    ('les cruders', 10000 * 100),
    ('padaria joia de cocaia', 100000 * 100),
    ('kid mais', 5000 * 100);

CREATE TABLE IF NOT EXISTS transacoes (
                                          id SERIAL PRIMARY KEY,
                                          cliente_id INTEGER NOT NULL,
                                          valor INTEGER NOT NULL,
                                          tipo CHAR(1) NOT NULL,
                                          descricao VARCHAR(10) NOT NULL,
                                          realizada_em TIMESTAMP NOT NULL DEFAULT NOW(),
                                          CONSTRAINT fk_clientes_transacoes_id
                                              FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE INDEX IF NOT EXISTS transacoes_clientes_id ON transacoes (cliente_id);

CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE TABLE IF NOT EXISTS clientes (
                                        id SERIAL PRIMARY KEY NOT NULL,
                                        nome VARCHAR(100) NOT NULL,
                                        limite int DEFAULT 0,
                                        saldo int DEFAULT 0
);

CREATE INDEX IF NOT EXISTS clientes_id ON clientes (id);


INSERT INTO clientes (nome, limite)
VALUES
    ('o barato sai caro', 1000 * 100),
    ('zan corp ltda', 800 * 100),
    ('les cruders', 10000 * 100),
    ('padaria joia de cocaia', 100000 * 100),
    ('kid mais', 5000 * 100);

CREATE TABLE IF NOT EXISTS transacoes (
                                          id SERIAL PRIMARY KEY,
                                          cliente_id INTEGER NOT NULL,
                                          valor INTEGER NOT NULL,
                                          tipo CHAR(1) NOT NULL,
                                          descricao VARCHAR(10) NOT NULL,
                                          realizada_em TIMESTAMP NOT NULL DEFAULT NOW(),
                                          CONSTRAINT fk_clientes_transacoes_id
                                              FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE INDEX IF NOT EXISTS transacoes_clientes_id ON transacoes (cliente_id);

