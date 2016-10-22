drop table toy cascade constraints purge;

drop table toy_attribute cascade constraints purge;

create table toy (
  id int,
  name varchar2(32),
  price decimal(6,2),
  primary key (id)
);

create table toy_attribute (
  id int,
  toy_id int,
  attr_name varchar2(32),
  attr_value varchar2(32),
  constraint fk_toy_attribute_toy_id foreign key (toy_id) references toy(id),
  primary key (id)
);

insert into toy values (1, 'car', 120.50);
insert into toy values (2, 'teddy', 13.25);

insert into toy_attribute values (1, 1, 'engine_size', '12L');
insert into toy_attribute values (2, 1, 'petrol_or_diesel', 'petrol');
insert into toy_attribute values (3, 2, 'material', 'Cotton');
insert into toy_attribute values (4, 2, 'age', '3');

select toy.name, toy_attribute.attr_name, toy_attribute.attr_value 
from toy
join toy_attribute
on toy.id = toy_attribute.toy_id
where name = 'teddy'
and toy_attribute.toy_id = 2;