create or replace trigger trig_matches_goals
before insert on matches 
for each row
begin
	if (:new.goal_a < 0 or :new.goal_b < 0)
	then
		raise_application_error(-20002, 'Invalid number of goals');
  end if;
end;