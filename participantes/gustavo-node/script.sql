CREATE TABLE clientes (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(30) NOT NULL,
  limite INTEGER NOT NULL,
  saldo INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE transacoes(
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    valor INTEGER NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cliente_id FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);
-- CREATE UNIQUE INDEX idx_clientes_id ON clientes USING btree (id);
CREATE INDEX idx_transacoes_cliente_id ON transacoes USING btree (cliente_id);

INSERT INTO clientes (nome, limite)
VALUES
  ('o barato sai caro', 1000 * 100),
  ('zan corp ltda', 800 * 100),
  ('les cruders', 10000 * 100),
  ('padaria joia de cocaia', 100000 * 100),
  ('kid mais', 5000 * 100);

-- CREATE OR REPLACE FUNCTION apagar_registro_mais_antigo() RETURNS TRIGGER AS $$
-- BEGIN
--     IF (SELECT count(*) FROM transacoes) > 10 THEN
--         DELETE FROM transacoes
--         WHERE id = (SELECT id FROM transacoes ORDER BY realizada_em ASC LIMIT 1);
--     END IF;
--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;
--
-- CREATE TRIGGER trigger_apagar_registro_mais_antigo
-- AFTER INSERT ON transacoes
-- FOR EACH ROW
-- EXECUTE FUNCTION apagar_registro_mais_antigo();
