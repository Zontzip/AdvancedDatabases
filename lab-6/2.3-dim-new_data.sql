/***********************
 * New data
 **********************/
insert into players1 (p_id, p_name, p_sname, team_id) values (7, 'Alan', 'Parker', 1);
insert into players1 (p_id, p_name, p_sname, team_id) values (8, 'Martha', 'Bag', 2);
insert into tournament1 (t_id, t_descriprion, t_date, total_price) values (5, 'Saudi Open', '01-sep-2014', 500000);

insert into results1 (t_id, p_id, rank, price) values (5, 1, 1, 60000);
insert into results1 (t_id, p_id, rank, price) values (5, 7, 5, 20000);
insert into results1 (t_id, p_id, rank, price) values (2, 8, 3, 1000);

/* Insert player data */
insert into stage_players (source_db, player_id, player_fname, player_sname, 
team_id)
select 1, p_id, p_name, p_sname, team_id from players1
where not exists (select * 
                  from stage_players sp 
                  where sp.player_id = players1.p_id
                  and sp.source_db = 1
);

insert into dim_players (player_sk, player_name)
  select sp.player_sk, sp.player_fname || ' ' || sp.player_sname  
  from stage_players sp
  where not exists (
    select * from dim_players dp
    where sp.player_sk = dp.player_sk
    or dp.player_name = sp.player_fname || ' ' || sp.player_sname);

/* Insert tournament data */
insert into stage_tournaments (source_db, tour_id, tour_desc, tour_date, 
tour_prize)
select 1, t_id, t_descriprion, t_date, total_price from tournament1
where not exists (select * 
                  from stage_tournaments st 
                  where st.tour_id = tournament1.t_id
                  and st.source_db = 1
);

insert into dim_tournaments (tournament_sk, tournament_desc, total_prize)
  select tour_sk, tour_desc, tour_prize
  from stage_tournaments st
  where not exists (select *
                    from dim_tournaments dt
                    where st.tour_sk = dt.tournament_sk
);

/* Insert date data */
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
from tournament1
where not exists (select *
                  from stage_dates sd
                  where sd.tour_date = tournament1.t_date
                  and sd.source_db = 1
);

insert into dim_dates(date_sk, d_day, d_month, d_year, d_week, d_quarter, 
d_dayofweek)
  select date_sk, d_day, d_month, d_year, d_week, d_quarter, d_dayofweek
  from stage_dates sd
  where not exists (select *
                    from dim_dates dd
                    where dd.date_sk = sd.date_sk
);

/* Insert result data */
insert into stage_facts (f_rank, f_prize, player_id, tour_id, team_id, 
tour_date, source_db)
  select r1.rank, r1.price, r1.p_id, r1.t_id, t1.team_id, tn1.t_date, 1
  from results1 r1
  join players1 p1 on p1.p_id = r1.p_id
  join team1 t1 on t1.team_id = p1.team_id
  join tournament1 tn1 on tn1.t_id = r1.t_id
where not exists (
  select *
  from stage_facts sf
  where sf.player_id = r1.p_id
  and sf.tour_id = r1.t_id
  and sf.team_id = t1.team_id
);

/* Set surrogate keys */
update stage_facts sf
set player_sk = (
  select player_sk 
  from stage_players sp
  where sp.source_db = sf.source_db 
  and sp.player_id = sf.player_id);

-- Normalize data
update stage_facts sf
set player_sk = 1 
where player_id = 2
and source_db = 2;

update stage_facts sf
set player_sk = 5 
where player_id = 1
and source_db = 2;

update stage_facts sf
set tournament_sk = (
  select tour_sk 
  from stage_tournaments st
  where st.source_db = sf.source_db 
  and st.tour_id = sf.tour_id);

update stage_facts sf
set team_sk = (
  select team_sk
  from stage_teams st
  where st.source_db = sf.source_db 
  and st.team_id = sf.team_id
);

-- Normalize data
update stage_facts sf
set team_sk = 1 
where team_id = 3
and source_db = 2;

update stage_facts sf
set date_sk = (
  select date_sk
  from stage_dates sd
  where sd.source_db = sf.source_db 
  and sd.tour_date = sf.tour_date
);

/* Update facts table */
insert into fact_results(player_sk, tournament_sk, team_sk, date_sk, f_rank, f_prize)
  select player_sk, tournament_sk, team_sk, date_sk, f_rank, f_prize
  from stage_facts sf
where not exists (select *
                  from fact_results
                  where fact_results.player_sk = sf.player_sk
                  and fact_results.tournament_sk = sf.tournament_sk
                  and fact_results.team_sk = sf.team_sk
                  and fact_results.date_sk = sf.date_sk
);