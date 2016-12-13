/* Create ER */
/* Important: a customer can buy a specific item only once a year! */
drop table Sales1;
drop table Sales2;
drop table Customer1;
drop table Customer2;
drop table Item1;
drop table Item2;

drop table fact_sales;
drop table DimItem;
drop table DimCustomer;
drop table DimYear;

drop table customer_stage;
drop table item_stage;
drop table year_stage;
drop table fact_stage;

drop sequence c_stage_seq;
drop sequence it_stage_seq;
drop sequence year_stage_seq;

Create Table Customer1(
c_id integer primary key,
c_name varchar(100),
gender integer);


Create Table Item1(
i_id integer primary key,
i_name varchar(100));

Create Table Sales1(
c_id integer,
it_id integer,
total float,
s_date date,
CONSTRAINT  FK_customer1 FOREIGN KEY (c_id) REFERENCES customer1,
CONSTRAINT  FK_item1 FOREIGN KEY (it_id) REFERENCES item1,
CONSTRAINT PK_sales1 PRIMARY KEY (it_id,c_id,s_date)
);

/* Create ER */
Create Table Customer2(
c_id integer primary key,
c_name varchar(100),
gender varchar(10));


Create Table Item2(
i_id integer primary key,
i_name varchar(100));

Create Table Sales2(
c_id integer,
it_id integer,
total float,
s_date date,
CONSTRAINT  FK_customer2 FOREIGN KEY (c_id) REFERENCES customer2,
CONSTRAINT  FK_item2 FOREIGN KEY (it_id) REFERENCES item2,
CONSTRAINT PK_sales2 PRIMARY KEY (it_id,c_id,s_date)
);

/* customer 1 */
insert into customer1 values (1,'mark',0);
insert into customer1 values (2,'mary',1);
insert into customer1 values (3,'matt',0);
insert into customer1 values (4,'john',0);
insert into customer1 values (5,'sam',0);
insert into customer1 values (6,'pat',0);
/* customer 2 */
insert into customer2 values (1,'carl','male');
insert into customer2 values (2,'jim','male');
insert into customer2 values (3,'laura','female');
insert into customer2 values (4,'sarah','female');
insert into customer2 values (5,'paul','male');
insert into customer2 values (6,'jane','female');
/* item 1 */
insert into item1 values (1,'lemon');
insert into item1 values (2,'apple');
insert into item1 values (3,'strawberry');
insert into item1 values (4,'salad');
insert into item1 values (5,'oranges');
insert into item1 values (6,'cucumber');
/*item 2 */
insert into item2 values (1,'pasta');
insert into item2 values (2,'rice');
insert into item2 values (3,'beef');
insert into item2 values (4,'lamb');
insert into item2 values (5,'bacon');
insert into item2 values (6,'hamburger');

/* sales 1 */
insert into sales1 values(1,1,200,'10-nov-2009');
insert into sales1 values(1,2,500,'10-jan-2010');
insert into sales1 values(2,3,400,'10-mar-2009');
insert into sales1 values(2,4,500,'10-mar-2011');
insert into sales1 values(3,1,700,'10-nov-2012');
insert into sales1 values(4,2,500,'10-nov-2010');
insert into sales1 values(4,4,600,'10-dec-2010');
insert into sales1 values(4,5,800,'10-nov-2010');
insert into sales1 values(5,6,600,'10-nov-2011');
insert into sales1 values(5,6,200,'10-dec-2013');
insert into sales1 values(6,1,300,'10-oct-2012');
insert into sales1 values(6,1,2500,'10-nov-2010');

/* sales 2 */
insert into sales2 values(1,4,200,'10-nov-2009');
insert into sales2 values(6,2,500,'10-jan-2010');
insert into sales2 values(2,3,400,'10-mar-2009');
insert into sales2 values(1,4,500,'10-mar-2011');
insert into sales2 values(3,1,700,'10-nov-2012');
insert into sales2 values(4,4,500,'10-nov-2010');
insert into sales2 values(4,5,600,'10-dec-2010');
insert into sales2 values(6,6,800,'10-nov-2010');
insert into sales2 values(5,1,600,'10-nov-2011');
insert into sales2 values(5,2,200,'10-dec-2013');
insert into sales2 values(4,3,300,'10-oct-2012');
insert into sales2 values(3,1,2500,'10-nov-2010');

select * from customer1;
select * from customer2;
select * from sales1;
select * from sales2;
select * from item1;
select * from item2;


/* DIMENSIONAL MODEL */
create Table DimItem(
item_sk integer primary key,
item_name varchar(100)
);

create table DimCustomer(
c_sk integer primary key,
c_name varchar(100),
gender varchar(10));

create table DimYear(
year_sk integer primary key,
year_value integer);

create table fact_sales(
item_sk integer,
c_sk integer,
year_sk integer,
total float,
CONSTRAINT  FK_dimcustomer FOREIGN KEY (c_sk) REFERENCES dimCustomer,
CONSTRAINT  FK_dimitem FOREIGN KEY (item_sk) REFERENCES DimItem,
CONSTRAINT  FK_dimyear FOREIGN KEY (year_sk) REFERENCES Dimyear,
CONSTRAINT PK_factsales PRIMARY KEY (item_sk,c_sk,year_sk));


