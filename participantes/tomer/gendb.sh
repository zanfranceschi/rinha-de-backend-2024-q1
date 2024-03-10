rm -rf dbs
mkdir dbs

sqlite3 dbs/customer1.db "DROP TABLE IF EXISTS balance;" "DROP TABLE IF EXISTS transactions;" "CREATE TABLE transactions (type TEXT,date TEXT,value INTEGER,description TEXT);" "CREATE TABLE balance (value INTEGER, min INTEGER CHECK(value >= -100000));" "INSERT INTO balance (value, min) values (0,100000);" ".exit"

sqlite3 dbs/customer2.db "DROP TABLE IF EXISTS balance;" "DROP TABLE IF EXISTS transactions;" "CREATE TABLE transactions (type TEXT,date TEXT,value INTEGER,description TEXT);" "CREATE TABLE balance (value INTEGER, min INTEGER CHECK(value >= -80000));" "INSERT INTO balance (value, min) values (0,80000);" ".exit"

sqlite3 dbs/customer3.db "DROP TABLE IF EXISTS balance;" "DROP TABLE IF EXISTS transactions;" "CREATE TABLE transactions (type TEXT,date TEXT,value INTEGER,description TEXT);" "CREATE TABLE balance (value INTEGER, min INTEGER CHECK(value >= -1000000));" "INSERT INTO balance (value, min) values (0,1000000);" ".exit"

sqlite3 dbs/customer4.db "DROP TABLE IF EXISTS balance;" "DROP TABLE IF EXISTS transactions;" "CREATE TABLE transactions (type TEXT,date TEXT,value INTEGER,description TEXT);" "CREATE TABLE balance (value INTEGER, min INTEGER CHECK(value >= -10000000));" "INSERT INTO balance (value, min) values (0,10000000);" ".exit"

sqlite3 dbs/customer5.db "DROP TABLE IF EXISTS balance;" "DROP TABLE IF EXISTS transactions;" "CREATE TABLE transactions (type TEXT,date TEXT,value INTEGER,description TEXT);" "CREATE TABLE balance (value INTEGER, min INTEGER CHECK(value >= -500000));" "INSERT INTO balance (value, min) values (0,500000);" ".exit"

