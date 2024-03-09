-- object: public.cliente | type: TABLE --
DROP TABLE IF EXISTS public.cliente CASCADE;
CREATE TABLE public.cliente (
	id smallint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	nome varchar(25) not null,
	limite bigint NOT NULL,
	saldo bigint NOT NULL default 0,
    version bigint NOT NULL DEFAULT 0,
	CONSTRAINT cliente_pk PRIMARY KEY (id)
);

-- object: public.transacao | type: TABLE --
DROP TABLE IF EXISTS public.transacao CASCADE;
CREATE TABLE public.transacao (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY,
	cliente smallint NOT NULL,
	tipo varchar(1) NOT NULL,
	valor bigint NOT NULL,
	descricao varchar(10) not null,
	criado_em timestamptz NOT NULL,
	CONSTRAINT transacao_pk PRIMARY KEY (id)

);

-- object: transacao_cliente_fk | type: CONSTRAINT --
ALTER TABLE public.transacao DROP CONSTRAINT IF EXISTS transacao_cliente_fk CASCADE;
ALTER TABLE public.transacao ADD CONSTRAINT transacao_cliente_fk FOREIGN KEY (cliente)
REFERENCES public.cliente (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Criação da função
CREATE OR REPLACE FUNCTION verificar_saldo_suficiente()
RETURNS TRIGGER AS $$
DECLARE
    novo_saldo bigint;
BEGIN
    -- Verifica se o tipo de transação é 'D' (débito).
    IF NEW.tipo = 'd' THEN
        -- Calcula o novo saldo após o débito.
        novo_saldo := (SELECT saldo - NEW.valor FROM cliente WHERE id = NEW.cliente);

        -- Verifica se o novo saldo está dentro do limite.
        IF novo_saldo >= - (SELECT limite FROM cliente WHERE id = NEW.cliente) THEN
            -- Atualiza o saldo do cliente.
            UPDATE cliente
            SET saldo = novo_saldo, version = version + 1
            WHERE id = NEW.cliente;

            RETURN NEW;
        ELSE
            RAISE EXCEPTION 'Saldo insuficiente para o débito. Limite excedido.';
        END IF;
    ELSE
        -- Para outros tipos de transação, como depósito, apenas atualiza o saldo.
        UPDATE cliente
        SET saldo = saldo + NEW.valor, version = version + 1
        WHERE id = NEW.cliente;

        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Criação do gatilho que chama a função antes da inserção na tabela transacao
CREATE OR REPLACE TRIGGER before_insert_transacao
BEFORE INSERT ON public.transacao
FOR EACH ROW EXECUTE FUNCTION verificar_saldo_suficiente();

DO $$
BEGIN
  INSERT INTO cliente (nome, limite)
  VALUES
    ('o barato sai caro', 1000 * 100),
    ('zan corp ltda', 800 * 100),
    ('les cruders', 10000 * 100),
    ('padaria joia de cocaia', 100000 * 100),
    ('kid mais', 5000 * 100);
END; $$;

