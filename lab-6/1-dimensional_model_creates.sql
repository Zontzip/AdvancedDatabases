drop table dim_players cascade constraints purge;
drop table dim_tournaments cascade constraints purge;
drop table dim_teams cascade constraints purge;
drop table dim_dates cascade constraints purge;
drop table fact_results cascade constraints purge;

create table dim_players (
  player_sk integer primary key,
  player_name varchar(50)
);

create table dim_tournaments (
  tournament_sk integer primary key,
  tournament_desc varchar(100),
  total_price float
);

create table dim_teams (
  team_sk integer primary key,
  team_name varchar (100)
);

create table dim_dates (
  date_sk integer primary key,
  d_day integer,
  d_month integer,
  d_year integer,
  d_week integer,
  d_quarter integer,
  d_dayofweek integer
);

create table fact_results (
  player_sk integer,
  tournament_sk integer,
  team_sk integer,
  date_sk integer,
  f_rank integer,
  f_price float,
  constraint player_fk foreign key (player_sk) references dim_players(player_sk),
  constraint tour_fk foreign key (tournament_sk) references dim_tournaments(tournament_sk),
  constraint team_fk foreign key (team_sk) references dim_teams(team_sk),
  constraint date_sk foreign key (date_sk) references dim_dates(date_sk),
  constraint res_fact_pk primary key (player_sk, tournament_sk, team_sk, date_sk)
);