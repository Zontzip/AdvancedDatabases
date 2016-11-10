/* ETL team dimension */ 
drop table stage_teams cascade constraints purge;

create table stage_teams (
  team_sk integer,
  source_db integer,
  team_name varchar(100)
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

insert into stage_teams (source_db, team_name)
select 1, team_name from team1;

insert into stage_teams (source_db, team_name)
select 2, team_name from team2;

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

insert into stage_players (source_db, player_id, player_fname, player_sname, team_id)
select 1, p_id, p_name, p_sname, team_id from players1;

insert into stage_players (source_db, player_id, player_fname, player_sname, team_id)
select 2, p_id, p_name, p_sname, team_id from players2;

select * from stage_players;

/* ETL tournament dimension */

