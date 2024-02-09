CREATE TABLE clients (
     id SERIAL PRIMARY KEY,
     balance INTEGER NOT NULL,
     total_limit INTEGER NOT NULL
);

CREATE TABLE transactions (
  id SERIAL PRIMARY KEY,
  client_id INTEGER REFERENCES clients(id),
  value INTEGER NOT NULL,
  type "char" CHECK (type IN ('c', 'd')) NOT NULL,
  description VARCHAR(10) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT current_timestamp NOT NULL
);

insert into clients
(id, total_limit, balance)
values
    (1, 100000, 0),
    (2, 80000, 0),
    (3, 1000000, 0),
    (4, 10000000, 0),
    (5, 500000, 0)
