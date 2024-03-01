TRUNCATE clientes CASCADE;
TRUNCATE transacoes CASCADE;

ALTER SEQUENCE clientes_id_seq RESTART WITH 1;
ALTER SEQUENCE transacoes_id_seq RESTART WITH 1;

DO $$
BEGIN
  INSERT INTO clientes (nome, limite, created_at, updated_at)
  VALUES
    ('o barato sai caro', 1000 * 100, NOW(), NOW()),
    ('zan corp ltda', 800 * 100, NOW(), NOW()),
    ('les cruders', 10000 * 100, NOW(), NOW()),
    ('padaria joia de cocaia', 100000 * 100, NOW(), NOW()),
    ('kid mais', 5000 * 100, NOW(), NOW());
END; $$
