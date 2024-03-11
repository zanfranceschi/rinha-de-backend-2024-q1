CREATE TABLE "Account" (
    "Id" INTEGER PRIMARY KEY,
    "Limit" INTEGER NOT NULL,
    "Value" INTEGER NOT NULL,
    CONSTRAINT "MinValue" CHECK ("Value" >= -"Limit")
);

CREATE TABLE "Statement" (
    "Id" SERIAL PRIMARY KEY,
    "AccountId" INTEGER REFERENCES "Account" ("Id"),
    "Value" INTEGER NOT NULL,
    "Type" CHAR NOT NULL,
    "Description" VARCHAR(10) NOT NULL,
    "Date" TIMESTAMP NOT NULL
);