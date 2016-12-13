drop table stage_teams cascade constraints purge;
drop table stage_players cascade constraints purge;
drop table stage_tournaments cascade constraints purge;
drop table stage_dates cascade constraints purge;
drop table stage_facts cascade constraints purge;

/***********************
 * ETL team dimension
 **********************/
create table stage_teams (
  team_sk integer,
  source_db integer,
  team_name varchar(100),
  team_id integer
);

drop sequence stage_team_seq;

create sequence stage_team_seq
start with 1
increment by 1
nomaxvalue;

create trigger stage_team_trigger 
before insert on stage_teams
for each row
begin
select stage_team_seq.nextval into :new.team_sk from dual;
end;

/*************************
 * ETL players dimension
 ************************/
create table stage_players (
  player_sk integer,
  source_db integer,
  player_id integer,
  player_fname varchar(50),
  player_sname varchar(50),
  team_id integer
);

drop sequence stage_player_seq;

create sequence stage_player_seq
start with 1
increment by 1
nomaxvalue;

create trigger stage_player_trigger 
before insert on stage_players
for each row
begin
select stage_player_seq.nextval into :new.player_sk from dual;
end;

/****************************
 * ETL tournament dimension
 ***************************/
create table stage_tournaments (
  tour_sk integer,
  source_db integer,
  tour_id integer,
  tour_desc varchar(100),
  tour_date date,
  tour_prize float
);

drop sequence stage_tournament_seq;

create sequence stage_tournament_seq
start with 1
increment by 1
nomaxvalue;

create trigger stage_tournament_trigger 
before insert on stage_tournaments
for each row
begin
select stage_tournament_seq.nextval into :new.tour_sk from dual;
end;

/************************
 * ETL date dimension
 ***********************/
create table stage_dates (
  date_sk integer primary key,
  source_db integer,
  d_day integer,
  d_month integer,
  d_year integer,
  d_week integer,
  d_quarter integer,
  d_dayofweek integer,
  tour_date date
);

drop sequence date_stage_seq;

create sequence date_stage_seq 
start with 1 
increment by 1 
nomaxvalue; 

create trigger stage_date_trigger
before insert on stage_dates
for each row
begin
select date_stage_seq.nextval into :new.date_sk from dual;
end;

/****************************
 * ETL facts dimension
 ***************************/
create table stage_facts (
  player_sk integer,
  tournament_sk integer,
  team_sk integer,
  date_sk integer,
  f_rank integer,
  f_prize float,
  player_id integer,
  tour_id integer,
  team_id integer,
  tour_date date,
  source_db integer
);