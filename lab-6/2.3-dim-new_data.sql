/***********************
 * New data
 **********************/
insert into players1 (p_id, p_name, p_sname, team_id) values (7, 'Alan', 'Parker', 1);
insert into players1 (p_id, p_name, p_sname, team_id) values (8, 'Martha', 'Bag', 2);
insert into tournament1 (t_id, t_descriprion, total_price) values (5, 'Saudi Open', 500000);

insert into results1 (t_id, p_id, rank, price) values (5, 1, 1, 60000);
insert into results1 (t_id, p_id, rank, price) values (5, 7, 5, 20000);
insert into results1 (t_id, p_id, rank, price) values (2, 8, 3, 1000);

insert into stage_players (source_db, player_id, player_fname, player_sname, 
team_id)
select 1, p_id, p_name, p_sname, team_id from players1;
