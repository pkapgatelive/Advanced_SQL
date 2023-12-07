-- SQL View Statments
SET sql_mode = '';

/*

SQL View is a virtual table whose contents are obtained from an
existing table or table, called base tables
*/
Select *
from dept_emp; -- total 331,603 rows. Also same employees multiple entries.


select emp_no,
       from_date,
       to_date,
       count(emp_no) as Num
from dept_emp
group by emp_no
having Num>1;

-- Here is the way to create the view

CREATE
OR
REPLACE view v_dept_emp_latest_date as
    (select emp_no,
            max(from_date) as from_date,
            max(to_date) as to_date
     from dept_emp
     group by emp_no);

-- Check the view

select *
from v_dept_emp_latest_date;

-- Views - exercise
/*
1. Create a view that will extract the average salary of all managers registered in the database.
Round this value to the nearest cent.

2. If you have worked correctly, after executing the view from the “Schemas” section in Workbench,
you should obtain the value of 66924.27.
*/

create or replace view v_average_salary_of_managers as (
select dm.emp_no,
       round(avg(s.salary), 2)
from dept_manager dm
join salaries s on dm.emp_no = s.emp_no
group by dm.emp_no
order by dm.emp_no
);

