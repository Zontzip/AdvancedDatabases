create or replace trigger trig_teams_log
after insert on teams 
for each row
declare 
	TeamName varchar(50);
begin
	TeamName := :new.TeamName;
	insert into teams_log (date_added, team_name) values (sysdate, TeamName);
end;