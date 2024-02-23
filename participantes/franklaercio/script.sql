CREATE TABLE IF NOT EXISTS CUSTOMER
(
    id            SERIAL PRIMARY KEY,
    max_limit     INT NOT NULL,
    balance       INT NOT NULL
);

CREATE TABLE IF NOT EXISTS CUSTOMER_TRANSACTION
(
    id            SERIAL PRIMARY KEY,
    id_customer   INTEGER NOT NULL REFERENCES CUSTOMER,
    amount        INT NOT NULL,
    kind          VARCHAR(1) NOT NULL,
    description   VARCHAR(255) NOT NULL,
    created_at    TIMESTAMP NOT NULL
);

INSERT INTO CUSTOMER (max_limit, balance) VALUES (100000, 0);
INSERT INTO CUSTOMER (max_limit, balance) VALUES (80000, 0);
INSERT INTO CUSTOMER (max_limit, balance) VALUES (1000000, 0);
INSERT INTO CUSTOMER (max_limit, balance) VALUES (10000000, 0);
INSERT INTO CUSTOMER (max_limit, balance) VALUES (500000, 0);