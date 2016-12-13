drop table teams cascade constraints purge;
drop table matches cascade constraints purge;
drop table teams_log cascade constraints purge;

create table teams (
	team_id integer,
	team_name varchar(50),
	team_country varchar(50),
	constraint pk_team_id primary key(team_id)
);

create table matches (
	match_id integer,
	team_a_id integer,
	team_b_id integer,
	goal_a integer,
	goal_b integer,
	competition varchar(50),
	constraint fk_team_id_a foreign key(team_a_id) references teams(team_id),
	constraint fk_team_id_b foreign key(team_b_id) references teams(team_id),
	constraint pk_match_id primary key(match_id)
);

insert into teams values (1, 'Arsenal', 'England');
insert into teams values (2, 'Manchester United', 'England');
insert into teams values (3, 'Chelsea', 'England');
insert into teams values (4, 'Manchester City', 'England');
insert into teams values (5, 'Barcellona', 'Spain');
insert into teams values (6, 'Real Madrid', 'Spain');		
insert into teams values (7, 'Getafe', 'Spain');
insert into teams values (8, 'Sevilla', 'Spain');

create table teams_log (
	date_added date,
	team_name varchar(50)
);

/* Test competition trigger */
insert into matches values (1, 1, 2, 0, 1, 'Champions League');

/* Test team country trigger */
insert into teams values (9, 'Dundalk', 'Ireland');
insert into matches values (2, 8, 9, 6, 0, 'La Liga');

/* Test goals scored >= 0 */
insert into matches values (3, 1, 2, 0, 0, 'La Liga');

/* Test if both teams home country are part of the same competition, 
pass and fail */
insert into matches values (4, 6, 8, 0, 1, 'La Liga');
insert into matches values (5, 1, 8, 2, 0, 'La Liga');

/* Check that a team has no more than 3 home matches */
insert into matches values (6, 3, 1, 1, 3, 'Premier League');
insert into matches values (7, 3, 2, 4, 2, 'Premier League');
insert into matches values (8, 3, 4, 2, 1, 'Premier League');
insert into matches values (9, 3, 1, 6, 1, 'Premier League');
