/*************************
 * Start teams inserts
 ************************/
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
/*************************
 * Start player inserts
 ************************/
insert into stage_players (source_db, player_id, player_fname, player_sname, 
team_id)
select 1, p_id, p_name, p_sname, team_id from players1;

insert into stage_players (source_db, player_id, player_fname, player_sname, 
team_id)
select 2, p_id, p_name, p_sname, team_id from players2;

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

/****************************
 * Start tournament inserts
 ***************************/
insert into stage_tournaments (source_db, tour_id, tour_desc, tour_date, 
tour_prize)
select 1, t_id, t_descriprion, t_date, total_price from tournament1;

insert into stage_tournaments (source_db, tour_id, tour_desc, tour_date, 
tour_prize)
select 2, t_id, t_descriprion, t_date, total_price from tournament2;

update stage_tournaments
set tour_prize = (tour_prize * 0.7)
where source_db = 2;

insert into dim_tournaments (tournament_sk, tournament_desc, total_prize)
  select tour_sk, tour_desc, tour_prize
  from stage_tournaments;
-- End tournament inserts  

/****************************
 * Start date inserts
 ***************************/
insert into stage_dates (source_db, d_day, d_month, d_year, d_week, d_quarter, 
d_dayofweek, tour_date)
select  1,
        cast(to_char(t_date,'DD') as integer),
        cast(to_char(t_date,'MM') as integer),
        cast(to_char(t_date,'YYYY') as integer),
        cast(to_char(t_date,'WW') as integer),
        cast(to_char(t_date,'Q') as integer),
        cast(to_char(t_date,'D') as integer),
        t_date
from tournament1;

insert into stage_dates (source_db, d_day, d_month, d_year, d_week, d_quarter, 
d_dayofweek, tour_date)
select  2,
        cast(to_char(t_date,'DD') as integer),
        cast(to_char(t_date,'MM') as integer),
        cast(to_char(t_date,'YYYY') as integer),
        cast(to_char(t_date,'WW') as integer),
        cast(to_char(t_date,'Q') as integer),
        cast(to_char(t_date,'D') as integer),
        t_date
from tournament2;

insert into dim_dates(date_sk, d_day, d_month, d_year, d_week, d_quarter, 
d_dayofweek)
  select date_sk, d_day, d_month, d_year, d_week, d_quarter, d_dayofweek
  from stage_dates;

/*************************
 * Start fact inserts
 ************************/
insert into stage_facts (f_rank, f_prize, player_id, tour_id, team_id, 
tour_date, source_db)
  select r1.rank, r1.price, r1.p_id, r1.t_id, t1.team_id, tn1.t_date, 1
  from results1 r1
  join players1 p1 on p1.p_id = r1.p_id
  join team1 t1 on t1.team_id = p1.team_id
  join tournament1 tn1 on tn1.t_id = r1.t_id;

insert into stage_facts (f_rank, f_prize, player_id, tour_id, team_id, 
tour_date, source_db)
  select r2.rank, r2.price, r2.p_id, r2.t_id, t2.team_id, tn2.t_date, 2
  from results2 r2
  join players2 p2 on p2.p_id = r2.p_id
  join team2 t2 on t2.team_id = p2.team_id
  join tournament2 tn2 on tn2.t_id = r2.t_id;

update stage_facts
set f_prize = (f_prize * 0.7)
where source_db = 2;
  
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
  and st.team_id = sf.team_id
);

/* Date SK */
update stage_facts sf
set date_sk = (
  select date_sk
  from stage_dates sd
  where sd.source_db = sf.source_db 
  and sd.tour_date = sf.tour_date
);