CREATE TABLE if not EXISTS transaction (
    id SERIAL PRIMARY KEY,
    client_id int NOT NULL,
    role varchar(255) NOT NULL,
    description varchar(255) NOT NULL,
    value int NOT NULL,
    realized_at timestamp with time zone NOT NULL
);

CREATE INDEX client_id ON transaction (client_id);