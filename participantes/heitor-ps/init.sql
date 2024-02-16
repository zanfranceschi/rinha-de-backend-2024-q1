CREATE TABLE IF NOT EXISTS users (
	id INTEGER PRIMARY KEY,
	balance INTEGER,
	"limit" INTEGER
);

CREATE TABLE IF NOT EXISTS transactions (
	id SERIAL PRIMARY KEY,
	user_id INTEGER,
	"value" INTEGER,
	"type" VARCHAR(1),
	description VARCHAR(10),
	created TIMESTAMP,
	
	CONSTRAINT fk_users
      FOREIGN KEY(user_id) 
        REFERENCES users("id")
);


INSERT INTO users (id, "limit", balance)
VALUES
(1, 100000, 0),
(2, 80000, 0),
(3, 1000000, 0),
(4, 10000000, 0),
(5, 500000, 0);
