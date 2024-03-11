DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS transactions;

CREATE TABLE clients (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  credit_limit INT NOT NULL,
  balance INT NOT NULL
);

CREATE TABLE transactions (
  id SERIAL PRIMARY KEY,
  client_id INT NOT NULL,
  value INT NOT NULL,
  type CHAR NOT NULL,
  description VARCHAR(10) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_client
    FOREIGN KEY (client_id)
      REFERENCES clients(id)
);

INSERT INTO clients (name, credit_limit, balance)
VALUES
  ('o barato sai caro', 1000 * 100, 0),
  ('zan corp ltda', 800 * 100, 0),
  ('les cruders', 10000 * 100, 0),
  ('padaria joia de cocaia', 100000 * 100, 0),
  ('kid mais', 5000 * 100, 0);
