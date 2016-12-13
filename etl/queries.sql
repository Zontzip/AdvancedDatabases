/* Select all tournaments tiger woods participated in */
select dp.player_name, dt.tournament_desc
from dim_tournaments dt
join fact_results fr on fr.tournament_sk = dt.tournament_sk
join dim_players dp on dp.player_sk = fr.player_sk
where dp.player_name = 'Tiger Woods';