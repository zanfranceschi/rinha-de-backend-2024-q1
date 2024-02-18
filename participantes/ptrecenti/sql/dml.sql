
DO $$
    BEGIN
        INSERT INTO clientes (nome, limite)
        VALUES
            ('o barato sai caro', 1000 * 100),
            ('zan corp ltda', 800 * 100),
            ('les cruders', 10000 * 100),
            ('padaria joia de cocaia', 100000 * 100),
            ('kid mais', 5000 * 100);

        INSERT INTO saldos (cliente_id, valor)
        SELECT id, 0 FROM clientes;
    END;
$$;