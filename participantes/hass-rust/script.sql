CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    limit_value INT8 NOT NULL,
    current INT8 NOT NULL
);

DO $$ BEGIN
INSERT INTO
    clientes (limit_value, current)
VALUES
    (1000 * 100, 0),
    (800 * 100, 0),
    (10000 * 100, 0),
    (100000 * 100, 0),
    (5000 * 100, 0);
END $$;

CREATE TABLE transactions (
    client_id INT REFERENCES clientes(id),
    value INT8 NOT NULL,
    type CHAR NOT NULL,
    description VARCHAR(10) NOT NULL,
    timestamp TIMESTAMP NOT NULL
);