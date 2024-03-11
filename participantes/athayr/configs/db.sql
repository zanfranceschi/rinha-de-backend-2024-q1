\c rinha
BEGIN;
CREATE TABLE "cliente"(
    "id" smallserial NOT NULL,
    "nome" VARCHAR NOT NULL,
    "saldo" INTEGER NOT NULL,
    "limite" INTEGER NOT NULL
);

ALTER TABLE "cliente" ADD PRIMARY KEY("id");

CREATE TABLE "transacao"(
    "id" bigserial NOT NULL,
    "valor" INTEGER NOT NULL,
    "tipo" VARCHAR(1) NOT NULL,
    "descricao" VARCHAR(10) NOT NULL,
    "cliente_id" SMALLINT NOT NULL,
    "realizada_em" TIMESTAMP NOT NULL DEFAULT NOW()
);

ALTER TABLE "transacao" ADD PRIMARY KEY("id");
ALTER TABLE "transacao" ADD CONSTRAINT "transacao_cliente_id_foreign" FOREIGN KEY("cliente_id") REFERENCES "cliente"("id");

CREATE INDEX "cliente_id_index" ON "cliente"("id");
CREATE INDEX "transacao_cliente_id_id_idx" ON transacao (cliente_id, "id");

INSERT INTO cliente (nome, limite, saldo)
VALUES
    ('o barato sai caro', 1000 * 100, 0),
    ('zan corp ltda', 800 * 100, 0),
    ('les cruders', 10000 * 100, 0),
    ('padaria joia de cocaia', 100000 * 100, 0),
    ('kid mais', 5000 * 100, 0);

COMMIT;
