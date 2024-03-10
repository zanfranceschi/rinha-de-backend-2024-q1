CREATE TABLE clients
(
    id      INT           NOT NULL PRIMARY KEY,
    name    VARCHAR(10)   NOT NULL,
    balance INT DEFAULT 0 NOT NULL,
    "limit" INT           NOT NULL
);

INSERT INTO clients (id, name, "limit")
VALUES (1, 'Client 1', 100000),
       (2, 'Client 2', 80000),
       (3, 'Client 3', 1000000),
       (4, 'Client 4', 10000000),
       (5, 'Client 5', 500000);

CREATE TABLE transactions
(
    id          BIGSERIAL PRIMARY KEY,
    client_id   INT         NOT NULL,
    amount      INT         NOT NULL CHECK (amount > 0),
    type        char        NOT NULL CHECK ( type IN ('c', 'd') ),
    description VARCHAR(10) NOT NULL,
    created_at  TIMESTAMP   NOT NULL,
    FOREIGN KEY (client_id) REFERENCES clients (id)
);

CREATE INDEX transactions_client_id_idx ON transactions (client_id);