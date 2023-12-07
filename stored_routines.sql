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


-- SQL Variables
-- Variable created using the SET keyword followed by the @

SET @v_avg_salary = 0;

select @v_avg_salary;

call employees.emp_avg_salary_out(11300, @v_avg_salary);

select @v_avg_salary;

/*
In MySQL, variables can be categorized into two main types: local variables and user-defined variables.

1. **Local Variables:**
   Local variables are declared and used within a stored program (like stored procedures, 
   functions, and triggers). They are only accessible within the scope of the block in which they are defined.

   - **Syntax for Declaring Local Variables:**
     ```sql
     DECLARE variable_name datatype [DEFAULT value];
     ```
     
-- Example:
     ```sql
     DECLARE my_variable INT DEFAULT 0;
     ```

-- **Example of Local Variable in a Stored Procedure:**
     ```sql
     CREATE PROCEDURE example_procedure()
     BEGIN
         DECLARE my_variable INT DEFAULT 0;

         -- Rest of the procedure logic using my_variable
     END;
     ```

2. **User-Defined Variables:**
   User-defined variables are session-specific and are set using 
   the `@` symbol followed by the variable name. They can be used to store values 
   temporarily and can be accessed across multiple statements within the same session.

   - **Syntax for User-Defined Variables:**
     ```sql
     SET @variable_name = value;
     ```
     Example:
     ```sql
     SET @my_variable = 42;
     ```

   - **Example of Using User-Defined Variable in a Query:**
     ```sql
     SELECT * FROM my_table WHERE column1 = @my_variable;
     ```

   - **Note:** User-defined variables do not require declaration.

It's important to differentiate between local variables and 
user-defined variables, as their scoping rules and use cases differ. 
Local variables are typically used within stored programs, 
while user-defined variables are more commonly used in ad-hoc queries or 
scripts to store and pass values within a session.

*/


-- Variables - exercise
/*
Create a variable, called ‘v_emp_no’, where you will store the output of the procedure you created in the last exercise.

Call the same procedure, inserting the values ‘Aruna’ and ‘Journel’ as a first and last name respectively.

Finally, select the obtained output.

*/
-- Solution
SET @v_emp_no = 0;

call emp_info('Aruna', 'Journel', @v_emp_no);

SELECT @v_emp_no;

-- USer Defined Function in Mysql
/*
In MySQL, a User-Defined Function (UDF) is a custom function created by the user to perform specific operations 
or computations. Unlike stored procedures, which are a set of SQL statements with a name, parameters, 
and a return type, user-defined functions return a single value and can be used in SQL expressions 
wherever an expression is valid.

Here is the basic syntax for creating a simple user-defined function:

CREATE FUNCTION function_name (parameters)
RETURNS return_type
BEGIN
    -- Function logic
    RETURN result;
END;


*/