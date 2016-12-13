create or replace trigger trig_matches_comp
before insert on matches 
for each row
begin
	if (:new.competition not in ('Champions League','Europa League', 'Premier League', 'La Liga'))
	then
		raise_application_error(-20000, 'Competition is not valid');
  end if;
end;