CREATE TABLE clientes
(
    id INT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    limite_conta INTEGER NOT NULL,
    saldo INTEGER NOT NULL DEFAULT 0
);

CREATE TYPE TipoOperacao AS ENUM('c', 'd');

CREATE TABLE transacoes
(
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    valor INTEGER NOT NULL,
    tipo TipoOperacao NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    criado_em TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_transactions_client_id
        FOREIGN KEY (cliente_id) REFERENCES clientes (id)
);

CREATE INDEX idx_transacoes_cliente_id ON transacoes (cliente_id);
CREATE INDEX idx_transacoes_criado_em ON transacoes (criado_em);

INSERT INTO clientes (id, nome, limite_conta)
VALUES
    (1, 'Van Hohenheim', 100000),
    (2, 'Edward Elric', 80000),
    (3, 'Alphonse Elric', 1000000),
    (4, 'Roy Mustang', 10000000),
    (5, 'Winry Rockbell', 500000);

