create or replace trigger trig_matches_country
before insert on matches 
for each row
declare
	team_country_a varchar(50);
	team_country_b varchar(50);
begin
	select team_country into team_country_a
	from teams
	where team_id = :new.team_a_id;

	select team_country into team_country_b
	from teams
	where team_id = :new.team_b_id;

	if (team_country_a not in ('England', 'Spain') or
      team_country_b not in ('England', 'Spain'))
	then
		raise_application_error(-20001, 'Country is not valid');
  end if;
end;