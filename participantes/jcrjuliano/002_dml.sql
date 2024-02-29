--insert into TB_CLIENTES (limite, saldo) values (100000, 0);
--insert into TB_CLIENTES (limite, saldo) values (80000, 0);
--insert into TB_CLIENTES (limite, saldo) values (1000000, 0);
--insert into TB_CLIENTES (limite, saldo) values (10000000, 0);
--insert into TB_CLIENTES (limite, saldo) values (500000, 0);
DO $$
BEGIN
  INSERT INTO TB_CLIENTES ("name", "limite")
  VALUES
    ('o barato sai caro', 1000 * 100),
    ('zan corp ltda', 800 * 100),
    ('les cruders', 10000 * 100),
    ('padaria joia de cocaia', 100000 * 100),
    ('kid mais', 5000 * 100);
END; $$
