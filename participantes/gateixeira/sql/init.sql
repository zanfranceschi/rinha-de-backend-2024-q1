CREATE TABLE client (
    id SERIAL PRIMARY KEY,
    acc_limit INT NOT NULL,
    balance INT NOT NULL DEFAULT 0
);


CREATE TABLE transaction (
    id SERIAL PRIMARY KEY,
    client_id INT,
    amount INT,
    op CHAR(1),
    transaction_description VARCHAR(10) NOT NULL,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES client(id)
);

DO $$
BEGIN
  INSERT INTO client (id, acc_limit)
  VALUES
    (1, 1000 * 100),
    (2, 800 * 100),
    (3, 10000 * 100),
    (4, 100000 * 100),
    (5, 5000 * 100);
END; $$
