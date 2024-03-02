CREATE TABLE clients
(
    id      SERIAL PRIMARY KEY,
    balance INT NOT NULL,
    "limit" INT NOT NULL
);

CREATE TABLE transactions
(
    id          SERIAL PRIMARY KEY,
    value       INT         NOT NULL,
    type        CHAR(1)     NOT NULL,
    description VARCHAR(10) NOT NULL,
    created_at  TIMESTAMP   NOT NULL,
    client_id   INT         NOT NULL,
    FOREIGN KEY (client_id) REFERENCES clients (id)
);

INSERT INTO clients ("limit", balance)
VALUES (100000, 0),
       (80000, 0),
       (1000000, 0),
       (10000000, 0),
       (500000, 0);
