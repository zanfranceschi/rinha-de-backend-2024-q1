CREATE TABLE IF NOT EXISTS "clientes" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "saldo" INTEGER NOT NULL,
    "limite" INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS "transacoes" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "valor" INTEGER NOT NULL,
    "id_cliente" INTEGER NOT NULL,
    "tipo" TEXT NOT NULL, -- Altere para TEXT
    "descricao" VARCHAR(10) NOT NULL,
    "realizada_em" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ("id_cliente") REFERENCES "clientes"("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

INSERT INTO clientes (saldo, limite)
VALUES
    (0, 100000),
    (0, 80000),
    (0, 1000000),
    (0, 10000000),
    (0, 500000);
