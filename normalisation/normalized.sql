drop table app_reference cascade constraints purge;
create table app_reference(
  reference_id integer,
  ref_name varchar(100),
  ref_institute varchar(100),
  ref_statement varchar(500),
  primary key(reference_id)
);

drop table student cascade constraints purge;
create table student (
  student_id integer,
  student_name varchar(50),
  primary key(student_id)
);

drop table zip cascade constraints purge;
create table zip (
  zipcode varchar(7),
  street varchar(100),
  state varchar(30),
  primary key(zipcode, street)
);

drop table student_address cascade constraints purge;
create table student_address (
  zipcode varchar(7),
  street varchar(100),
  student_id integer,
  foreign key(zipcode, street) references zip(zipcode, street),
  foreign key(student_id) references student(student_id),
  primary key (zipcode, street, student_id)
);

drop table prior_school cascade constraints purge;
create table prior_school (
  prior_school_id integer,
  prior_school_addr varchar(100),
  primary key(prior_school_id)
);

drop table student_gpa cascade constraints purge;
create table student_gpa (
  student_id integer,
  prior_school_id integer,
  gpa integer,
  foreign key(student_id) references student(student_id),
  foreign key(prior_school_id) references prior_school(prior_school_id)
);

drop table application cascade constraints purge;
create table application (
  app_no integer,
  app_year integer,
  student_id integer,
  reference_id integer,
  foreign key(student_id) references student(student_id),
  foreign key(reference_id) references app_reference(reference_id),
  primary key(app_no, app_year)
);

insert into app_reference (reference_id, ref_name, ref_institute, ref_statement) values (1,'Dr. Jones','Trinity College','Good guy');
insert into app_reference (reference_id, ref_name, ref_institute, ref_statement) values (2,'Dr. Jones','U Limerick','Very Good guy');
insert into app_reference (reference_id, ref_name, ref_institute, ref_statement) values (3,'Dr. Byrne','DIT','Perfect');
insert into app_reference (reference_id, ref_name, ref_institute, ref_statement) values (4,'Dr. Byrne','UCD','Average');
insert into app_reference (reference_id, ref_name, ref_institute, ref_statement) values (5,'Dr. Jones','Trinity College','Poor');
insert into app_reference (reference_id, ref_name, ref_institute, ref_statement) values (6,'Prof. Cahill','UCC','Excellent');
insert into app_reference (reference_id, ref_name, ref_institute, ref_statement) values (7,'Prof. Lillis','DIT','Fair');
insert into app_reference (reference_id, ref_name, ref_institute, ref_statement) values (8,'Prof. Lillis','DIT','Good girl');
insert into app_reference (reference_id, ref_name, ref_institute, ref_statement) values (9,'Dr. Byrne','DIT','Perfect');
insert into app_reference (reference_id, ref_name, ref_institute, ref_statement) values (10,'Prof. Cahill','UCC','Messy');

insert into student (student_id, student_name) values(1,'Mark');
insert into student (student_id, student_name) values(2,'Sarah');
insert into student (student_id, student_name) values(3,'Paul');
insert into student (student_id, student_name) values(4,'Jack');
insert into student (student_id, student_name) values(5,'Mary');
insert into student (student_id, student_name) values(6,'Susan');

insert into zip (street, state, zipcode) values('Grafton Street','New York','NY234');
insert into zip (street, state, zipcode) values('White Street','Florida','FLO435');
insert into zip (street, state, zipcode) values('Green Road','California','FLO435');
insert into zip (street, state, zipcode) values('Red Crescent','Carolina','CA455');
insert into zip (street, state, zipcode) values('Yellow Park','Mexico','MEX1');
insert into zip (street, state, zipcode) values('Dartry Road','Ohio','OH34');
insert into zip (street, state, zipcode) values('Malahide Road','Ireland','IRE');
insert into zip (street, state, zipcode) values('Black Bay','Kansas','KAN45');
insert into zip (street, state, zipcode) values('River Road','Kansas','KAN45');

insert into student_address (zipcode, street, student_id) values ('NY234','Grafton Street', 1);
insert into student_address (zipcode, street, student_id) values ('FLO435','White Street', 1);
insert into student_address (zipcode, street, student_id) values ('CAL123','Green Road', 2);
insert into student_address (zipcode, street, student_id) values ('CA455', 'Red Crescent', 3);
insert into student_address (zipcode, street, student_id) values ('MEX1', 'Yellow Park', 3);
insert into student_address (zipcode, street, student_id) values ('OH34', 'Dartry Road', 4);
insert into student_address (zipcode, street, student_id) values ('IRE','Malahide Road', 5);
insert into student_address (zipcode, street, student_id) values ('KAN45','Black Bay', 5);
insert into student_address (zipcode, street, student_id) values ('KAN45','River Road', 6);

insert into prior_school (prior_school_id, prior_school_addr) values(1,'Castleknock');
insert into prior_school (prior_school_id, prior_school_addr) values(2,'Loreto College');
insert into prior_school (prior_school_id, prior_school_addr) values(3,'St. Patrick');
insert into prior_school (prior_school_id, prior_school_addr) values(4,'DBS');
insert into prior_school (prior_school_id, prior_school_addr) values(5,'Harvard');

insert into student_gpa (student_id, prior_school_id, gpa ) values (1,1,65);
insert into student_gpa (student_id, prior_school_id, gpa ) values (1,2,87);
insert into student_gpa (student_id, prior_school_id, gpa ) values (2,1,90);
insert into student_gpa (student_id, prior_school_id, gpa ) values (2,3,76);
insert into student_gpa (student_id, prior_school_id, gpa ) values (2,1,90);
insert into student_gpa (student_id, prior_school_id, gpa ) values (2,4,66);
insert into student_gpa (student_id, prior_school_id, gpa ) values (2,5,45);
insert into student_gpa (student_id, prior_school_id, gpa ) values (3,1,45);
insert into student_gpa (student_id, prior_school_id, gpa ) values (3,3,67);
insert into student_gpa (student_id, prior_school_id, gpa ) values (3,4,23);
insert into student_gpa (student_id, prior_school_id, gpa ) values (3,5,67);
insert into student_gpa (student_id, prior_school_id, gpa ) values (4,3,29);
insert into student_gpa (student_id, prior_school_id, gpa ) values (4,4,88);
insert into student_gpa (student_id, prior_school_id, gpa ) values (4,5,66);
insert into student_gpa (student_id, prior_school_id, gpa ) values (5,3,44);
insert into student_gpa (student_id, prior_school_id, gpa ) values (5,4,55);
insert into student_gpa (student_id, prior_school_id, gpa ) values (5,5,66);
insert into student_gpa (student_id, prior_school_id, gpa ) values (5,1,74);
insert into student_gpa (student_id, prior_school_id, gpa ) values (6,1,88);
insert into student_gpa (student_id, prior_school_id, gpa ) values (6,3,77);
insert into student_gpa (student_id, prior_school_id, gpa ) values (6,4,56);
insert into student_gpa (student_id, prior_school_id, gpa ) values (6,2,45);

insert into application (app_no, student_id, app_year, reference_id) values (1,1, 2003,1);
insert into application (app_no, student_id, app_year, reference_id) values (1,1,2004,1);
insert into application (app_no, student_id, app_year, reference_id) values (2,1,2007,1);
insert into application (app_no, student_id, app_year, reference_id) values (3,1,2012,2);
insert into application (app_no, student_id, app_year, reference_id) values (2,2,2010,3);
insert into application (app_no, student_id, app_year, reference_id) values (2,2,2011,3);
insert into application (app_no, student_id, app_year, reference_id) values (2,2,2012,4);
insert into application (app_no, student_id, app_year, reference_id) values (1,3,2012,5);
insert into application (app_no, student_id, app_year, reference_id) values (3,3,2008,6);
insert into application (app_no, student_id, app_year, reference_id) values (1,4,2009,7);
insert into application (app_no, student_id, app_year, reference_id) values (2,5,2009,8);
insert into application (app_no, student_id, app_year, reference_id) values (1,5,2005,9);
insert into application (app_no, student_id, app_year, reference_id) values (3,6,2011,10);


