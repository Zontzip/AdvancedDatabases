/* ERD 2: (0, 1) - (0, *) */
drop table book cascade constraints purge;

drop table membership cascade constraints purge;

drop table loan cascade constraints purge;

create table book (
  ISBN varchar2(32),
  title varchar2(64),
  primary key(ISBN)
);

create table membership (
  id number(8),
  name varchar2(64),
  primary key(id)
);

create table loan (
  book_ISBN varchar2(32), 
  membership_id number(8),
  date_borrowed date,
  date_returned date, 
  constraint fk_loan_book_isbn foreign key (book_ISBN) references book(ISBN),
  constraint fk_loan_membership_id foreign key (membership_id) references membership(id),
  primary key (book_ISBN, membership_id, date_borrowed)
);

insert into book values ('ABC123D', 'Harry Potter is a Rotter');
insert into book values ('ABC123F', 'Harry Potter returns to hogwarts');

insert into membership values (1234, 'Alex Kiernan');

insert into loan values ('ABC123D', 1234, '12-JUL-2016', '14-AUG-2016');
insert into loan values ('ABC123F', 1234, '14-JUL-2016', '16-AUG-2016');

select * from loan;