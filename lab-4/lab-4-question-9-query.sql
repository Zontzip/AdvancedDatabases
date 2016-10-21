/* Create temp table and select from that */
truncate table jobs_person_date;
drop table jobs_person_date;
create global temporary table jobs_person_date 
  on commit preserve rows
  as  select jp.jobs_id, jp.person_id 
      from jobs_person jp
      where jp.start_date> '01-JAN-2003' and jp.end_date < '31-DEC-2003';

select j.salary, j.job_description from jobs;

select p.person_name, j.salary, j.job_description 
from persons p 
join jobs_person_date jp on p.person_id = jp.person_id
join jobs j on jp.jobs_id = j.jobs_id;

/* Delete duplicates, if any */                    
DELETE FROM 
   jobs_person a
WHERE  a.rowid > ANY (
     SELECT b.rowid
     FROM jobs_person b
     WHERE a.jobs_id = b.jobs_id
     AND a.person_id = b.person_id
);

/* select person name, max salary and job description between 2003 and 2004 */
select p.person_name, j.salary, j.job_description 
from persons p 
join jobs_person jp on p.person_id = jp.person_id
join jobs j on jp.jobs_id=j.jobs_id
where jp.start_date> '01-JAN-2003' and jp.end_date < '31-DEC-2003';

/* Create indexes */
create index idx_jobs_person_jobs_id on jobs_person(jobs_id);
create index idx_jobs_person_person_id on jobs_person(person_id);

/* Select indexes */
create index idx_person_pname on persons(person_name);
create index idx_jobs_salary on jobs(salary);
create index idx_jobs_job_description on jobs(job_description);

/* Find duplicate composite keys */
select jobs_id, person_id, count(*)
from   jobs_person
group  by jobs_id, person_id 
order by count(*) desc;

/* Add composite primary key */
alter table jobs_person
add primary key (jobs_id, person_id);

/* Count number of rows */
select count(jobs_id) from JOBS_PERSON;