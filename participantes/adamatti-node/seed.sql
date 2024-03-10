do $$
begin
    truncate table "transactions";
    truncate table "clients";

    insert into "clients" ("id", "limit", "balance")
    values
        (1,   100000, 0),
        (2,    80000, 0),
        (3,  1000000, 0),
        (4, 10000000, 0),
        (5,   500000, 0);
end; $$
