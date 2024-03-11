CREATE TABLE clientes (
    id      SERIAL PRIMARY KEY,
    nome    VARCHAR(50) NOT NULL,
    limite   INT NOT NULL,
    saldo   INT DEFAULT 0 NOT NULL 
);


CREATE TABLE transacoes (
    id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL,
    valor INT NOT NULL,
    tipo VARCHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_clientes_transacoes_id FOREIGN KEY(cliente_id) REFERENCES clientes(id)
);


CREATE OR REPLACE FUNCTION create_transaction_func(
  p_cliente_id INTEGER,
  p_valor INTEGER,
  p_tipo CHAR(1),
  p_descricao VARCHAR(10), OUT v_saldo INT, OUT v_limite INT
)
LANGUAGE plpgsql
AS $$
BEGIN
  SELECT limite, saldo INTO v_limite, v_saldo FROM clientes WHERE id = p_cliente_id FOR UPDATE;

  IF p_tipo = 'c' THEN
    v_saldo = v_saldo + p_valor;
    UPDATE clientes SET saldo = saldo + p_valor WHERE id = p_cliente_id;
  ELSIF p_tipo = 'd' THEN
    IF (v_saldo + v_limite - p_valor) < 0 THEN
      RAISE EXCEPTION 'Limite insuficiente!';
    ELSE
	  v_saldo = v_saldo - p_valor;
      UPDATE clientes SET saldo = saldo - p_valor WHERE id = p_cliente_id;
    END IF;
  ELSE
    RAISE EXCEPTION 'Transacao Invalida!';
  END IF;

  INSERT INTO transacoes (cliente_id, valor, tipo, descricao)
  VALUES (p_cliente_id, p_valor, p_tipo, p_descricao);
END;
$$;

DO $$
BEGIN

    INSERT INTO clientes (nome, limite)
      VALUES
        ('Joao', 1000 * 100),
        ('Jose', 800 * 100),
        ('Maria', 10000 * 100),
        ('Pedro', 100000 * 100),
        ('Isabel', 5000 * 100);
END; $$