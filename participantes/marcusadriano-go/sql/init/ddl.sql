CREATE TABLE users (
  id            SERIAL PRIMARY KEY,
  name          VARCHAR(100) NOT NULL,
  balance       BIGINT NOT NULL,
  balance_limit BIGINT NOT NULL
);

CREATE TABLE transactions (
  id          UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
  user_id     INTEGER NOT NULL,
  amount      BIGINT NOT NULL,
  description VARCHAR(10) NOT NULL,
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ttype       CHAR(1) NOT NULL
);

CREATE INDEX transactions_user_id_idx ON transactions (user_id);
ALTER TABLE transactions ADD FOREIGN KEY (user_id) REFERENCES users (id);