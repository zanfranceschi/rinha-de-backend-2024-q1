\c dogfight

CREATE TABLE clients
(
    id            INT PRIMARY KEY,
    name          VARCHAR(50) NOT NULL,
    account_limit INTEGER     NOT NULL,
    balance       INTEGER     NOT NULL DEFAULT 0
);

CREATE TABLE transactions
(
    id          SERIAL PRIMARY KEY,
    client_id   INTEGER     NOT NULL,
    value       INTEGER     NOT NULL,
    operation   CHAR(1)     NOT NULL,
    description VARCHAR(10) NOT NULL,
    created_at  TIMESTAMP   NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_transactions_client_id
        FOREIGN KEY (client_id) REFERENCES clients (id)
);

DO
$$
    BEGIN
        INSERT INTO clients (id, name, account_limit)
        VALUES (1, 'Rocky Balboa', 100000),
               (2, 'Apollo Creed', 80000),
               (3, 'Mike Tyson', 1000000),
               (4, 'John Jones', 10000000),
               (5, 'Muhammad Ali', 500000);
    END;
$$