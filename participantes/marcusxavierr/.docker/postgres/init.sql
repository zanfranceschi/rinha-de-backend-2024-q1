CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR (256) NOT NULL,
    credit_limit INTEGER NOT NULL,
    balance INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    value INTEGER NOT NULL,
    type CHAR(1) NOT NULL,
    description VARCHAR(10),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

DO $$
BEGIN
INSERT INTO users (name, credit_limit)
  VALUES
    ('Paulo Brificado 🇧🇷', 1000 * 100),
    ('Sujyro Kimimame 🇯🇵', 800 * 100),
    ('Giuseppe Camole 🇮🇹', 10000 * 100),
    ('Jalan Bipau 🇮🇳', 100000 * 100),
    ('Jallim Habbei 🇸🇦', 5000 * 100);
END; $$;
