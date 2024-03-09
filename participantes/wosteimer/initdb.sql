CREATE TABLE Client (
    id SERIAL PRIMARY KEY,
    limit_value INT,
    balance INT
);

CREATE TABLE Transaction (
    id SERIAL PRIMARY KEY,
    client_id INT,
    value INT,
    kind CHAR(1) CHECK (kind IN ('c', 'd')),
    description VARCHAR(10),
    created_at TIMESTAMP WITH TIME ZONE,
    FOREIGN KEY (client_id) REFERENCES Client(id)
);

CREATE INDEX idx_client_id ON Transaction (client_id);


DO $$
BEGIN
  INSERT INTO Client(limit_value, balance) 
  VALUES
    (1000 * 100, 0),
    (800 * 100, 0),
    (10000 * 100, 0),
    (100000 * 100, 0),
    (5000 * 100, 0);
END; $$
