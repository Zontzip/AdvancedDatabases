/* ERD 4: (1, 1) - (0, 1) */
drop table department cascade constraints purge;
drop table employee cascade constraints purge;

create table employee (
    id number(8),
    name varchar(30),
    primary key (id)
);

create table department (
    name varchar2(32),
    lead_employee_id number(8) not null unique,
    constraint fk_department_led_by foreign key (lead_employee_id) references employee(id),
    primary key (name)
);

insert into employee values(1, 'Alex Kiernan');
insert into employee values(2, 'Rian Jolley');
insert into employee values(3, 'David Kiernan');

insert into department values('Sales', 1);
insert into department values('Marketing', 2);	