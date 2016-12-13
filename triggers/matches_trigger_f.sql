create or replace trigger trig_matches_correct_comp
before insert on matches 
for each row
declare
	home_matches integer;
begin
	select count(team_a_id) into home_matches
	from matches
	where team_a_id = :new.team_a_id;

	if home_matches = 3 then
		raise_application_error(-20005, 'Team already has 3 home matches');
	end if;
end;