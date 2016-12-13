create or replace trigger trig_matches_correct_comp
before insert on matches 
for each row
declare
	team_country_a varchar(50);
	team_country_b varchar(50);
	competition varchar(50);
begin
	select team_country into team_country_a
	from teams
	where team_id = :new.team_a_id;

	select team_country into team_country_b
	from teams
	where team_id = :new.team_b_id;

	competition := :new.competition;

	case competition
		when 'Premier League' then
			if (team_country_a != 'England' or team_country_b != 'England')
			then
				raise_application_error(-20003, 'Country is not in Premier League');
		  	end if;
		when 'La Liga' then
			if (team_country_a != 'Spain' or team_country_b != 'Spain')
			then
				raise_application_error(-20004, 'Country is not in La Liga');
		  	end if;
	end case;
	EXCEPTION
    WHEN CASE_NOT_FOUND THEN
      dbms_output.put_line('competition not found, ok to continue');
end;