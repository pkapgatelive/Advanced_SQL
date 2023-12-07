-- Store routines has two type of process:
-- 1. Stored Procedures
-- 2. Functions
-- 1. Stored Procedures
-- Syntax:
/*

DELIMITER $$ or //

Create Procedure Procedure_Name (param_1, param_2)

Here, Param_1 and Param_2 are represent certain values that the
procedure will use to complete the calculation it is supposed to
execute.

-- Procedure also can be created without parameters.

BEGIN

Select * from employees limit 1000;

END $$ or //

DELIMITER;

*/
-- Example; Return the first 1000 rows from the employees table

use employees;
/* Not worked in everu version of sql and it is also not standared process
Drop PROCEDURE if EXISTS select_employees;


DELIMITER $$
Create PROCEDURE select_employees()
BEGIN
    Select *
    from employees
limit
    1000;
END $$
DELIMITER;

*/

DROP PROCEDURE IF EXISTS select_employees;

CREATE PROCEDURE select_employees()
BEGIN
    SELECT *
    FROM employees
    LIMIT
    1000;
END;


-- Lets invoked the procedure,
-- 1. By call with database

call employees.select_employees
();


-- Stored procedures - Example - Part II - exercise
-- Create a procedure that will provide the average salary of all employees. Then, call the procedure.

Drop Procedure If Exists employees_average_salary;

Create Procedure employees_average_salary()
BEGIN
    select avg(salary)
    from salaries;
end;

call employees_average_salary();

-- SP with input parameters: we do use the in or out to input and send the result return

Drop
procedure
if EXISTS emp_salary;

Create procedure emp_salary(in p_emp_no INTEGER)
BEGIN
    select e.first_name, e.last_name, s.salary, s.from_date, s.to_date
    from employees e Join salaries s on e.emp_no = s.emp_no
    where e.emp_no = p_emp_no;
END;

call emp_salary(11300);


Drop
procedure
if EXISTS employees.emp_average_salary;

Create procedure employees.emp_average_salary(in p_emp_no INTEGER)

BEGIN
    select e.first_name, e.last_name, avg(s.salary) as avg_salary
    from employees.employees e Join employees.salaries s on e.emp_no = s.emp_no
    where e.emp_no = p_emp_no
    group by e.first_name, e.last_name;
END;

call employees.emp_average_salary(11300);


-- Store Procedure with the in and out variable.
-- In this need to keep in minid that we do use the in, out and into keywords while performing the store procesure.


Drop procedure if EXISTS emp_avg_salary_out;

Create procedure emp_avg_salary_out(in p_emp_no INTEGER, out p_avg_salary Decimal
(10,2))
BEGIN
    select Avg(s.salary)
    into p_avg_salary
    from employees e Join salaries s on e.emp_no = s.emp_no
    where e.emp_no = p_emp_no;
end;

-- Calling the procedure
-- set p_avg_salary = 0;

call emp_avg_salary_out(11300, @p_avg_salary);

select @p_avg_salary;


-- Stored procedures with an output parameter - exercise
/*
Create a procedure called ‘emp_info’ that uses as parameters 
the first and the last name of an individual, and returns their employee number.
*/

drop PROCEDURE if exists emp_info;

create procedure emp_info(in p_first_name CHAR
(10), in p_last_name char
(10), out p_emp_no int)
BEGIN
    select e.emp_no
    into p_emp_no
    from employees e
    where e.first_name = p_first_name and e.last_name = p_last_name limit 1;
END;

call emp_info
('Georgi',	'Facello', @p_emp_no);

SELECT @p_emp_no;

