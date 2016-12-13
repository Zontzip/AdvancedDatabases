/* INITIAL ETL */
/* Load Dimension Customers */
/* Staging Area */

create table customer_stage(
c_sk integer,
sourceDB integer,
c_id integer,
c_name varchar(100),
gender varchar(10));

create sequence c_stage_seq 
start with 1 
increment by 1 
nomaxvalue; 

drop trigger c_stage_trigger;

create trigger c_stage_trigger
before insert on customer_stage
for each row
begin
select c_stage_seq.nextval into :new.c_sk from dual;
end;

insert into customer_stage (sourcedb,c_id,c_name,gender) 
select 1,c_id,c_name,cast(gender as varchar(10)) from customer1;

insert into customer_stage (sourcedb,c_id,c_name,gender) 
select 2,c_id,c_name,cast(gender as varchar(10)) from customer2;

select * from customer_stage;

update customer_stage set gender='female' where gender='1';
update customer_stage set gender='male' where gender='0';

select * from customer_stage;

/*Load dimension customer */
insert into dimcustomer select c_sk,c_name,gender from customer_stage;

/* Dimension Items */
create table item_stage(
it_sk integer,
sourceDB integer,
it_id integer,
it_name varchar(100));

drop trigger it_stage_trigger;

create sequence it_stage_seq 
start with 1 
increment by 1 
nomaxvalue; 

create trigger it_stage_trigger
before insert on item_stage
for each row
begin
select it_stage_seq.nextval into :new.it_sk from dual;
end;

insert into item_stage (sourcedb,it_id,it_name) 
select 1,i_id,i_name from item1;

insert into item_stage (sourcedb,it_id,it_name) 
select 2,i_id,i_name from item2;

select * from item_stage;

insert into dimitem select it_sk,it_name from item_stage;

select * from dimitem;
/* end dimension item */

/* Dimension Date */
Create table year_stage(
year_sk integer primary key,
year_value integer);

create sequence year_stage_seq 
start with 1 
increment by 1 
nomaxvalue; 

drop trigger year_stage_trigger;

create trigger year_stage_trigger
before insert on year_stage
for each row
begin
select year_stage_seq.nextval into :new.year_sk from dual;
end;

insert into year_stage(year_value) select distinct cast(to_char(s_date,'YYYY') as integer)  from sales1;

select * from year_stage;

insert into year_stage(year_value) select distinct cast(to_char(s_date,'YYYY') 
as integer)  from sales2 s2 where
NOT EXISTS (SELECT * FROM year_stage ys
              WHERE cast(to_char(s2.s_date,'YYYY') as integer) = ys.year_value);

select * from year_stage;

insert into DimYear select year_sk,year_value from year_stage;

/* Loading Fact */

Create table fact_stage(
c_sk integer,
it_sk integer,
year_sk integer,
c_id integer,
it_id integer,
s_date integer,
total float,
sourcedb integer
);

insert into fact_stage(c_id,it_id,s_date,total,sourcedb) select c_id,it_id,
cast(to_char(s_date,'YYYY') as integer),total,1 from Sales1;

insert into fact_stage(c_id,it_id,s_date,total,sourcedb) 
select c_id,it_id,cast(to_char(s_date,'YYYY') as integer),total,2 from Sales2;

select * from fact_stage;
select * from customer_stage;

/* Assign Surrogate Keys */
/* Customer SK */
update fact_stage
set c_sk=
  (select customer_stage.c_sk from
  customer_stage  where (customer_stage.sourceDB=fact_stage.sourceDB and
  customer_stage.c_id = fact_stage.c_id));

select * from fact_stage;

/* Item SK */
update fact_stage
set it_sk=
  (select item_stage.it_sk from
  item_stage  where (item_stage.sourceDB=fact_stage.sourceDB and
  item_stage.it_id = fact_stage.it_id));

/* Date SK */
update fact_stage
set year_sk=
  (select year_stage.year_sk from
  year_stage  where (year_stage.year_value = fact_stage.s_date));

select * from fact_stage;  

insert into fact_sales select it_sk,c_sk,year_sk,total from fact_stage;

select * from fact_sales;  


/* END INITIAL ETL LOAD */

/* Second ETL LOAD */
/* new data in database 1 */
/* 1 new customer */
insert into customer1 values (7,'kevin',0);
/* new item 1 */
insert into item1 values (7,'tomato');
/* new sales 1 */
insert into sales1 values(7,1,200,'10-nov-2009');
insert into sales1 values(7,2,500,'10-jan-2009');
insert into sales1 values(3,7,500,'10-jan-2009');
insert into sales1 values(5,5,500,'10-jan-2011');

/* SECOND ETL */
/* recognize existing entities and update them */
/* add new entities */
/* first use stage table, then load dimensions */
/* insert only new entities. Use the c_id + sourceDB to check if entity already existed */

/* In this example, there are no matching items or customers, all the new data are new, and there is no repetition of itesm or customers among the two databases*/
/* In a complete ETL, we should check and try to match items or/and customers from the two DBs. For instance, if there is a tomato item in both the DB, it should be 
merged into a single entity in the dimension*/

/* Dimension Customer */
insert into customer_stage (sourcedb,c_id,c_name,gender) 
select 1,c_id,c_name,cast(gender as varchar(10)) from customer1 c1 where
NOT EXISTS (SELECT * FROM customer_stage cs
              WHERE  cs.c_id= c1.c_id and cs.sourcedb=1 );  /* updating from database 1, add only NEW customers, use the business key! */

/* Normalize new data */
update customer_stage set gender='female' where gender='1';
update customer_stage set gender='male' where gender='0';
			  
			  
insert into dimcustomer select c_sk,c_name,gender from customer_stage cs where
NOT EXISTS (SELECT * FROM dimcustomer
              WHERE  cs.c_sk= dimcustomer.c_sk );  /* updating only new entities */

/* Dimension Item */
insert into item_stage (sourcedb,it_id,it_name) 
select 1,i_id,i_name from item1 where
NOT EXISTS (SELECT * FROM item_stage ist
              WHERE  ist.it_id= item1.i_id and ist.sourcedb=1 );  /* updating from database 1 */

insert into dimitem select it_sk,it_name from item_stage where
NOT EXISTS (SELECT * FROM dimitem di
              WHERE  item_stage.it_sk= di.item_sk );  /* updating only new entities */

/* Dimension Date */
insert into year_stage(year_value) select distinct cast(to_char(s_date,'YYYY') as integer)  from sales1 s1 where
NOT EXISTS (SELECT * FROM year_stage ys
              WHERE cast(to_char(s1.s_date,'YYYY') as integer) = ys.year_value);

insert into dimyear select year_sk,year_value from year_stage where
NOT EXISTS (SELECT * FROM dimyear dy
              WHERE  year_stage.year_sk= dy.year_sk );  /* updating only new entities */


/* Second Load Fact Table */
insert into fact_stage(c_id,it_id,s_date,total,sourcedb) select c_id,it_id,cast(to_char(s_date,'YYYY') as integer),total,1 from Sales1 s1 where
NOT EXISTS (SELECT * FROM fact_stage fs
              WHERE fs.c_id=s1.c_id and fs.it_id=s1.it_id and 
			  fs.s_date=cast(to_char(s1.s_date,'YYYY') as integer) 
			  and fs.sourcedb=1 );

select * from fact_stage;
/* Assign Surrogate Keys  - same sql code as before */
/* Customer SK */
update fact_stage
set c_sk=
  (select customer_stage.c_sk from
  customer_stage  where (customer_stage.sourceDB=fact_stage.sourceDB and
  customer_stage.c_id = fact_stage.c_id));

select * from fact_stage;

/* Item SK */
update fact_stage
set it_sk=
  (select item_stage.it_sk from
  item_stage  where (item_stage.sourceDB=fact_stage.sourceDB and
  item_stage.it_id = fact_stage.it_id));

/* Date SK */
update fact_stage
set year_sk=
  (select year_stage.year_sk from
  year_stage  where (year_stage.year_value = fact_stage.s_date));

select * from fact_sales;

insert into fact_sales select it_sk,c_sk,year_sk,total from fact_stage;


insert into fact_sales select it_sk,c_sk,year_sk,total from fact_stage where
NOT EXISTS (SELECT * FROM fact_sales fs
              WHERE  fact_stage.it_sk= fs.item_sk and fact_stage.c_sk= fs.c_sk and fact_stage.year_sk= fs.year_sk);  /* updating only new entities */

select * from fact_sales;

/* UPDATE FACT TABLE */
/* End of Second Load */