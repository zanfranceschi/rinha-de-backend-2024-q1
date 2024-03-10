CREATE DATABASE financial;

\c financial;

CREATE TABLE IF NOT EXISTS client (
  id SERIAL PRIMARY KEY,
  balanceLimit INT,
  balance INT
);

CREATE TABLE IF NOT EXISTS transaction (
  id SERIAL PRIMARY KEY,
  client_id INT,
  value INT,
  type VARCHAR(1),
  description VARCHAR(255),
  date TIMESTAMP, 
  FOREIGN KEY (client_id) REFERENCES client(id)
);


INSERT INTO client (balanceLimit, balance) VALUES 
(100000,0), 
(80000,0), 
(1000000,0), 
(10000000, 0), 
(500000, 0); 