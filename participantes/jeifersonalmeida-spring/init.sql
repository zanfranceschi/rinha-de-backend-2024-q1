create table customer (
	id int primary key,
	balance bigint,
	account_limit bigint
);

create table transaction (
	id serial primary key,
	value bigint,
	type char(1),
	description varchar(10),
	date varchar(30),
	customer_id int,
	constraint fk_customer foreign key (customer_id) references customer(id)
);

create index idx_transaction_customer on transaction(customer_id);

insert into customer values (1, 0, 100000);
insert into customer values (2, 0, 80000);
insert into customer values (3, 0, 1000000);
insert into customer values (4, 0, 10000000);
insert into customer values (5, 0, 500000);