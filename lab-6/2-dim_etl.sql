/* ETL team dimension */ 
drop table stage_teams cascade constraints purge;

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

insert into stage_teams (source_db, team_name, team_id)
select 1, team_name, team_id from team1;

insert into stage_teams (source_db, team_name, team_id)
select 2, team_name, team_id from team2;

/* Insert from DB 1 */
insert into dim_teams (team_sk, team_name)
  select st.team_sk, st.team_name 
  from stage_teams st
  where not exists (
    select team_name
    from dim_teams dt
    where dt.team_name = st.team_name)
  and source_db = 1; 

/* Insert from DB 2 */
insert into dim_teams (team_sk, team_name)
  select st.team_sk, st.team_name 
  from stage_teams st
  where not exists (
    select team_name
    from dim_teams dt
    where dt.team_name = st.team_name)
and source_db = 2; 
-- End team ETL

/* ETL players dimension */
drop table stage_players cascade constraints purge;

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

insert into stage_players (source_db, player_id, player_fname, player_sname, 
team_id)
select 1, p_id, p_name, p_sname, team_id from players1;

insert into stage_players (source_db, player_id, player_fname, player_sname, 
team_id)
select 2, p_id, p_name, p_sname, team_id from players2;

select * from stage_players;

/* Insert from DB 1 */
insert into dim_players (player_sk, player_name)
  select sp.player_sk, sp.player_fname || ' ' || sp.player_sname  
  from stage_players sp
  where not exists (
    select player_name
    from dim_players dp
    where dp.player_name = sp.player_fname || ' ' || sp.player_sname )
  and source_db = 1; 

/* Insert from DB 2 */
insert into dim_players (player_sk, player_name)
  select sp.player_sk, sp.player_fname || ' ' || sp.player_sname  
  from stage_players sp
  where not exists (
    select player_name
    from dim_players dp
    where dp.player_name = sp.player_fname || ' ' || sp.player_sname )
  and source_db = 2; 
-- End player ETL

/* ETL tournament dimension */
drop table stage_tournaments cascade constraints purge;

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

insert into stage_tournaments (source_db, tour_id, tour_desc, tour_date, 
tour_prize)
select 1, t_id, t_descriprion, t_date, total_price from tournament1;

insert into stage_tournaments (source_db, tour_id, tour_desc, tour_date, 
tour_prize)
select 2, t_id, t_descriprion, t_date, total_price from tournament2;

insert into dim_tournaments (tournament_sk, tournament_desc, total_prize)
  select tour_sk, tour_desc, tour_prize
  from stage_tournaments;
-- End tournament ETL  

/* ETL date sk */
drop table stage_dates cascade constraints purge;

create table stage_dates (
  date_sk integer primary key,
  source_db integer,
  d_day integer,
  d_month integer,
  d_year integer,
  d_week integer,
  d_quarter integer,
  d_dayofweek integer
);

drop sequence date_stage_seq;

create sequence date_stage_seq 
start with 1 
increment by 1 
nomaxvalue; 

drop trigger stage_date_trigger;

create trigger stage_date_trigger
before insert on stage_dates
for each row
begin
select date_stage_seq.nextval into :new.date_sk from dual;
end;

insert into stage_dates (source_db, d_day, d_month, d_year, d_week, d_quarter, 
d_dayofweek)
select  2,
        cast(to_char(t_date,'DD') as integer),
        cast(to_char(t_date,'MM') as integer),
        cast(to_char(t_date,'YYYY') as integer),
        cast(to_char(t_date,'WW') as integer),
        cast(to_char(t_date,'Q') as integer),
        cast(to_char(t_date,'D') as integer)
from tournament1;

insert into dim_dates(date_sk, d_day, d_month, d_year, d_week, d_quarter, 
d_dayofweek)
  select date_sk, d_day, d_month, d_year, d_week, d_quarter, d_dayofweek
  from stage_dates;
-- End date ETL 

/* Facts */
drop table stage_facts cascade constraints purge;

create table stage_facts (
  player_sk integer,
  tournament_sk integer,
  team_sk integer,
  date_sk integer,
  f_rank integer,
  f_prize float,
  player_id integer,
  tour_id integer,
  source_db integer
);

insert into stage_facts (f_rank, f_prize, player_id, tour_id, source_db)
  select rank, price, p_id, t_id, 1
  from results1;

insert into stage_facts (f_rank, f_prize, player_id, tour_id, source_db)
  select rank, price, p_id, t_id, 2
  from results2;
  
/* Assign the surrogate keys */
/* Player SK */
update stage_facts sf
set player_sk = (
  select player_sk 
  from stage_players sp
  where sp.source_db = sf.source_db 
  and sp.player_id = sf.player_id);

/* Tournament SK */
update stage_facts sf
set tournament_sk = (
  select tour_sk 
  from stage_tournaments st
  where st.source_db = sf.source_db 
  and st.tour_id = sf.tour_id);
  
/* Team SK */
update stage_facts sf
set team_sk = (
  select team_sk 
  from stage_teams st
  where st.source_db = sf.source_db 
  and st.team_id = sf.team_id);