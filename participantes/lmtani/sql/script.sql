CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    limite INTEGER NOT NULL,
    saldo INTEGER DEFAULT 0
);

CREATE TABLE transacoes (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(id),
    valor INTEGER NOT NULL,
    tipo VARCHAR(1) NOT NULL,
    realizada_em TIMESTAMP NOT NULL,
    descricao VARCHAR(255)
);

CREATE INDEX idx_cliente_id_data ON transacoes (cliente_id, realizada_em DESC);

INSERT INTO clientes (nome, limite) VALUES
    ('o barato sai caro', 1000 * 100),
    ('zan corp ltda', 800 * 100),
    ('les cruders', 10000 * 100),
    ('padaria joia de cocaia', 100000 * 100),
    ('kid mais', 5000 * 100);


-- CREATE OR REPLACE FUNCTION update_saldo()
-- RETURNS TRIGGER AS $$
-- BEGIN
-- -- Calculate the new saldo first
-- DECLARE
-- new_saldo INTEGER;
-- BEGIN
-- SELECT saldo + NEW.valor INTO new_saldo
-- FROM clientes
-- WHERE id = NEW.cliente_id;
--
-- -- Check if the new saldo exceeds the limite
-- IF new_saldo < -(SELECT limite FROM clientes WHERE id = NEW.cliente_id) THEN
-- RAISE EXCEPTION 'New saldo exceeds the limit';
-- END IF;
--
-- -- Update the saldo
-- UPDATE clientes SET saldo = new_saldo
-- WHERE id = NEW.cliente_id;
-- END;
-- RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;
--
--
-- CREATE TRIGGER saldo_update_trigger
-- AFTER INSERT ON transacoes
-- FOR EACH ROW
-- EXECUTE FUNCTION update_saldo();
