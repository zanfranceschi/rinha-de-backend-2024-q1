create table Customers(
    id serial primary key,
    account_limit int not null,
    balance int not null
);

create type transactions_kind as enum ('credit','debit');

create table Transactions(
    id serial primary key,
    value int not null,
    description varchar(10) not null,
    kind transactions_kind not null,
    created_at timestamptz not null,
    customer_id int not null,
    constraint fk_customers foreign key(customer_id) references Customers(id) 
);

insert into Customers (id,account_limit,balance) values 
(1,100000,0),
(2,80000,0),
(3,1000000,0),
(4,10000000,0),
(5,500000,0);
