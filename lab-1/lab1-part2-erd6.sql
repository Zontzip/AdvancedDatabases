/* ERD 6: (1, 1) - (1, 1) */
drop table capital cascade constraints purge;

drop table city cascade constraints purge;

drop table country cascade constraints purge;

create table country (
  name varchar2(32),
  population number(16),
  primary key (name)
);

create table city (
  id number(8) not null,
  name varchar2(32) not null,
  longitude varchar2(8),
  latitude varchar2(8),
  primary key (id)
);

create table capital (
  city_id number(8) unique,
  country varchar2(30) unique,
  province varchar2(30),
  constraint fk_capital_city_id foreign key (city_id) references city(id),
  constraint fk_capital_country foreign key (country) references country(name),
  primary key (city_id, country)
);

insert into country values ('Ireland', 4595000);

insert into city values (1, 'Dublin', '53.4129', '8.2439');

insert into capital values (1, 'Ireland', 'Leinster');

select * from capital;