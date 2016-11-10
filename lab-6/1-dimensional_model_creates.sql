drop table player_dim cascade constraints purge;
drop table tournament_dim cascade constraints purge;
drop table team_dim cascade constraints purge;
drop table date_dim cascade constraints purge;
drop table results_fact cascade constraints purge;

create table player_dim (
  player_sk integer primary key,
  player_name varchar(50)
);

create table tournament_dim (
  tournament_sk integer primary key,
  tournament_desc varchar(100),
  total_price float
);

create table team_dim (
  team_sk integer primary key,
  team_name varchar (100)
);

create table date_dim (
  date_sk integer primary key,
  d_day integer,
  d_month integer,
  d_year integer,
  d_week integer,
  d_quarter integer,
  d_dayofweek integer
);

create table results_fact (
  player_sk integer,
  tournament_sk integer,
  team_sk integer,
  date_sk integer,
  f_rank integer,
  f_price float,
  constraint player_fk foreign key (player_sk) references player_dim(player_sk),
  constraint tour_fk foreign key (tournament_sk) references tournament_dim(tournament_sk),
  constraint team_fk foreign key (team_sk) references team_dim(team_sk),
  constraint date_sk foreign key (date_sk) references date_dim(date_sk),
  constraint res_fact_pk primary key (player_sk, tournament_sk, team_sk, date_sk)
);