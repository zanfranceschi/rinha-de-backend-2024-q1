DO $$ BEGIN
INSERT INTO clientes (limite, saldo)
VALUES (1000 * 100, 0),
     (800 * 100, 0),
     (10000 * 100, 0),
     (100000 * 100, 0),
     (5000 * 100, 0);
END;
$$
