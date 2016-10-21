/* Original query */

/* Create temp table with indexes and select from that */
truncate table jobs_person_date;
drop table jobs_person_date;

create global temporary table jobs_person_date (
  jobs_id integer, 
  person_id integer);
      
create index idx_temp_jobs_person_jobs_id on jobs_person_date(jobs_id);
create index idx_temp_jobs_person_person_id on jobs_person_date(person_id);

insert into jobs_person_date
(select jp.jobs_id, jp.person_id 
      from jobs_person jp
      where jp.start_date> '01-JAN-2003' and jp.end_date < '31-DEC-2003');

select p.person_name, j.salary, j.job_description 
from persons p 
join jobs_person_date jp on p.person_id = jp.person_id
join jobs j on jp.jobs_id = j.jobs_id;