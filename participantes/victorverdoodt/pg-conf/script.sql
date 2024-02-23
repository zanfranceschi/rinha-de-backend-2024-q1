-- Criação da tabela Customers
CREATE UNLOGGED TABLE "Customers" (
    "Id" SERIAL PRIMARY KEY,
    "Name" VARCHAR(255) NOT NULL,
    "Balance" INT NOT NULL,
    "Limit" INT NOT NULL,
    "LastStatement" TEXT
);

-- Inserção de dados na tabela Customers
INSERT INTO "Customers" ("Name", "Balance", "Limit")
VALUES
    ('o barato sai caro', 0, 1000 * 100),
    ('zan corp ltda', 0, 800 * 100),
    ('les cruders', 0, 10000 * 100),
    ('padaria joia de cocaia', 0, 100000 * 100),
    ('kid mais', 0, 5000 * 100);

