CREATE VIEW v_checa_saldo_cliente AS
SELECT 
    c.id,
    c.nome,
    c.limite,
    s.valor AS saldo_atual,
    (COALESCE(valor_credito, 0) - COALESCE(valor_debito, 0)) AS saldo_calculado,
    s.valor - (COALESCE(valor_credito, 0) - COALESCE(valor_debito, 0)) AS dif_saldo,
    COALESCE(tot_c, 0) AS tot_transacao_c,
    COALESCE(tot_d, 0) AS tot_transacao_d
FROM
    public.cliente c
JOIN
    public.saldocliente s ON c.id = s.cliente_id
LEFT JOIN (
    SELECT 
        cliente_id,
        COUNT(1) AS tot_c,
        SUM(valor) AS valor_credito
    FROM 
        public.transacao
    WHERE 
        tipo = 'c'
    GROUP BY 
        cliente_id
) AS total_credito ON c.id = total_credito.cliente_id
LEFT JOIN (
    SELECT 
        cliente_id,
        COUNT(1) AS tot_d,
        SUM(valor) AS valor_debito
    FROM 
        public.transacao
    WHERE 
        tipo = 'd'
    GROUP BY 
        cliente_id
) AS total_debito ON c.id = total_debito.cliente_id
ORDER BY 
    c.id;

