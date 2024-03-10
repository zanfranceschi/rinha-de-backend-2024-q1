CREATE UNLOGGED TABLE clientes (
    id BIGSERIAL PRIMARY KEY NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    limite INTEGER NOT NULL,
    saldo INTEGER DEFAULT 0
);

CREATE UNLOGGED TABLE transacoes (
    id SERIAL PRIMARY KEY NOT NULL,
    cliente_id INT NOT NULL,
    valor INTEGER NOT NULL,
    tipo VARCHAR(1) NOT NULL,
    descricao VARCHAR(10) ,
    realizada_em timestamp with time zone DEFAULT now(),
    CONSTRAINT fk_clientes FOREIGN KEY (cliente_id) 
        REFERENCES clientes(id)
);

DO $$
BEGIN
  INSERT INTO clientes (limite)
  VALUES
    (1000 * 100),
    (800 * 100),
    (10000 * 100),
    (100000 * 100),
    (5000 * 100);
END; $$