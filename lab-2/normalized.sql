drop table referee cascade constraints purge;
drop table school cascade constraints purge;
drop table address cascade constraints purge;
drop table student cascade constraints purge;
drop table student_address cascade constraints purge;
drop table application cascade constraints purge;
drop table application_school_info cascade constraints purge;
drop table application_reference_info cascade constraints purge;

create table referee (
  ref_name varchar(100),
  ref_institution  varchar(100),
  primary key (ref_name, ref_institution)
);

create table school (
  school_ID integer,
  school_addr varchar(100),
  primary key (school_ID)
);

create table address (
  zip varchar(7),
  state varchar(30),
  street varchar(100),
  primary key (zip, street)
);

create table student (
  student_ID integer,
  student_name varchar(50),
  primary key (student_ID)
);

create table student_address (
  student_ID integer,
  zip varchar(7),
  street varchar(100),
  foreign key (student_ID) references student(student_ID),
  foreign key (zip, street) references address(zip, street),
  primary key (student_ID, zip, street)
);

create table application (
  app_no integer,
  app_year integer,
  student_ID integer,
  foreign key (student_ID) references student(student_ID),
  primary key (app_no, app_year)
);

create table application_school_info (
  app_no integer,
  app_year integer,
  student_ID integer,
  school_ID integer,
  GPA number(2),
  foreign key (app_no, app_year) references application(app_no, app_year),
  foreign key (student_ID) references student(student_ID),
  foreign key (school_ID) references school(school_ID),
  primary key (app_no, app_year, student_ID, school_ID)
);

create table application_reference_info (
  app_no integer,
  app_year integer,
  student_ID integer,
  school_ID integer,
  ref_name varchar(100),
  ref_institution  varchar(100),
  ref_statement varchar(500),
  foreign key (app_no, app_year) references application(app_no, app_year),
  foreign key (student_ID) references student(student_ID),
  foreign key (school_ID) references school(school_ID),
  foreign key (ref_name, ref_institution) references referee(ref_name, ref_institution),
  primary key (app_no,app_year,student_ID,school_ID,ref_name,ref_institution)
);

insert into referee values ('Dr. Jones','Trinity College');
insert into referee values ('Dr. Jones','U Limerick');
insert into referee values ('Dr. Byrne','DIT');
insert into referee values ('Dr. Byrne','UCD');
insert into referee values ('Prof. Cahill','UCC');
insert into referee values ('Prof. Lillis','DIT');

insert into school values(1,'Castleknock');
insert into school values(2,'Loreto College');
insert into school values(3,'St. Patrick');
insert into school values(4,'DBS');
insert into school values(5,'Harvard');

insert into address values('NY234','New York','Grafton Street');
insert into address values('Flo435','Florida','White Street');
insert into address values('Cal123','California','Green Road');
insert into address values('Ca455','Carolina','Red Crescent');
insert into address values('Mex1','Mexico','Yellow Park');
insert into address values('Oh34','Ohio','Dartry Road');
insert into address values('IRE','Ireland','Malahide Road');
insert into address values('Kan45','Kansas','Black Bay');
insert into address values('Kan45','Kansas','River Road');

insert into student values(1,'Mark');
insert into student values(2,'Sarah');
insert into student values(3,'Paul');
insert into student values(4,'Jack');
insert into student values(5,'Mary');
insert into student values(6,'Susan');

insert into student_address values(1,'NY234','Grafton Street');
insert into student_address values(1,'Flo435','White Street');
insert into student_address values(2,'Cal123','Green Road');
insert into student_address values(3,'Ca455','Red Crescent');
insert into student_address values(3,'Mex1','Yellow Park');
insert into student_address values(4,'Oh34','Dartry Road');
insert into student_address values(5,'IRE','Malahide Road');
insert into student_address values(5,'Kan45','Black Bay');
insert into student_address values(6,'Kan45','River Road');

insert into application values(1,2003,1);
insert into application values(1,2004,1);
insert into application values(2,2007,1);
insert into application values(3,2012,1);
insert into application values(2,2010,2);
insert into application values(2,2011,2);
insert into application values(2,2012,2);
insert into application values(1,2012,3);
insert into application values(3,2008,3);
insert into application values(1,2009,4);
insert into application values(2,2009,5);
insert into application values(1,2005,5);
insert into application values(3,2011,6);

insert into application_school_info values(1,2003,1,1,65);
insert into application_school_info values(1,2004,1,1,65);
insert into application_school_info values(2,2007,1,1,65);
insert into application_school_info values(2,2007,1,2,87);
insert into application_school_info values(3,2012,1,1,65);
insert into application_school_info values(3,2012,1,2,87);
insert into application_school_info values(2,2010,2,1,90);
insert into application_school_info values(2,2010,2,3,76);

insert into application_reference_info values(1,2003,1,1,'Dr. Jones','Trinity College','Good Guy');
insert into application_reference_info values(1,2004,1,1,'Dr. Jones','Trinity College','Good Guy');
insert into application_reference_info values(2,2007,1,1,'Dr. Jones','Trinity College','Good Guy');
insert into application_reference_info values(2,2007,1,2,'Dr. Jones','Trinity College','Good Guy');