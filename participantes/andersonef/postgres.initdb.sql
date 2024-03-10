ALTER SYSTEM SET max_connections = 300;
/*ALTER SYSTEM SET shared_buffers = "75MB";
ALTER SYSTEM SET effective_cache_size = "225MB";
ALTER SYSTEM SET maintenance_work_mem = "19200kB";
ALTER SYSTEM SET checkpoint_completion_target = 0.9;
ALTER SYSTEM SET wal_buffers = "2304kB";
ALTER SYSTEM SET default_statistics_target = 100;
ALTER SYSTEM SET random_page_cost = 1.1;
ALTER SYSTEM SET effective_io_concurrency = 200;
ALTER SYSTEM SET work_mem = "76kB";
ALTER SYSTEM SET huge_pages = off;
ALTER SYSTEM SET min_wal_size = "1GB";
ALTER SYSTEM SET max_wal_size = "4GB";*/

CREATE UNLOGGED TABLE IF NOT EXISTS clientes (id INTEGER PRIMARY KEY, limite INTEGER, saldo INTEGER DEFAULT 0);
INSERT INTO clientes (id, limite) VALUES (1, 100000), (2, 80000), (3, 1000000), (4, 10000000), (5, 500000) ON CONFLICT DO NOTHING;
CREATE UNLOGGED TABLE IF NOT EXISTS transacoes (id SERIAL PRIMARY KEY, id_cliente INTEGER, valor INTEGER, tipo TEXT, descricao VARCHAR, realizada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY(id_cliente) REFERENCES clientes(id));
DELETE FROM transacoes;

CREATE OR REPLACE FUNCTION fn_add_transacao(p_id_cliente integer, p_valor INTEGER, p_tipo text, p_descricao text) 
RETURNS TABLE (status text, saldo INTEGER, limite integer) AS 
$$
DECLARE
   v_status text;
   v_saldo INTEGER;
   v_limite integer;
   v_novo_saldo INTEGER;
BEGIN
    SELECT c.saldo, c.limite INTO v_saldo, v_limite FROM clientes c WHERE c.id = p_id_cliente for update;
	v_novo_saldo := v_saldo + (CASE WHEN p_tipo = 'c' THEN p_valor ELSE -p_valor end);
    IF v_novo_saldo >= -v_limite THEN
        INSERT INTO transacoes (id_cliente, valor, tipo, descricao) VALUES (p_id_cliente, p_valor, p_tipo, p_descricao);
        
        UPDATE clientes SET saldo = v_novo_saldo WHERE id = p_id_cliente;

        v_status := 'success';
        RETURN QUERY SELECT v_status, v_novo_saldo, v_limite;
    ELSE
        v_status := 'error';
        RETURN QUERY SELECT v_status, v_saldo, v_limite;
    END IF;

    --RETURN QUERY SELECT v_status, (case when v_status = 'success' then v_novo_saldo else v_saldo end), v_limite;
END;
$$
LANGUAGE plpgsql;
