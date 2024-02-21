CREATE UNLOGGED TABLE cliente (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(30) NOT NULL,
  limite INTEGER NOT NULL,
  saldo INTEGER NOT NULL
);

CREATE UNLOGGED TABLE transacao (
    id SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL,
    tipo CHAR(1) NOT NULL,
    valor INTEGER NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    realizada_em TIMESTAMP NOT NULL,
    CONSTRAINT fk_clientes_transacoes_id
        FOREIGN KEY (id_cliente) REFERENCES cliente(id)
);

CREATE INDEX IF NOT EXISTS idx_cliente_id ON cliente(id);
CREATE INDEX IF NOT EXISTS idx_transacao_id_cliente_realizada_em_desc ON transacao(id_cliente, realizada_em DESC);


CREATE OR REPLACE FUNCTION update_balance(id_cliente INT, tipo_transacao CHAR(1), valor_transacao NUMERIC, OUT text_message TEXT, OUT is_error BOOLEAN, OUT updated_balance NUMERIC, OUT client_limit NUMERIC) AS $$
DECLARE
    client_record RECORD;
    limite_cliente NUMERIC;
    saldo_cliente NUMERIC;
BEGIN
    SELECT * INTO client_record FROM cliente WHERE id = id_cliente FOR UPDATE;
    IF NOT FOUND THEN
        text_message := 'Cliente não encontrado';
        is_error := true;
        updated_balance := 0;
        client_limit := 0;
        RETURN;
    END IF;
    limite_cliente := client_record.limite;
    IF tipo_transacao = 'c' THEN
        saldo_cliente := client_record.saldo + valor_transacao;
    ELSIF tipo_transacao = 'd' THEN
        saldo_cliente := client_record.saldo - valor_transacao;
        IF limite_cliente + saldo_cliente < 0 THEN
            text_message := 'Limite foi ultrapassado';
            is_error := true;
            updated_balance := 0;
            client_limit := 0;
            RETURN;
        END IF;
    END IF;
    UPDATE cliente SET saldo = saldo_cliente WHERE id = id_cliente;
    text_message := 'Saldo do cliente atualizado com sucesso';
    is_error := false;
    updated_balance := saldo_cliente;
    client_limit := limite_cliente;
END;
$$ LANGUAGE plpgsql;

INSERT INTO cliente (id, nome, limite, saldo) VALUES
	(1, 'o barato sai caro', 1000 * 100, 0),
	(2, 'zan corp ltda', 800 * 100, 0),
	(3, 'les cruders', 10000 * 100, 0),
	(4, 'padaria joia de cocaia', 100000 * 100, 0),
	(5, 'kid mais', 5000 * 100, 0);
