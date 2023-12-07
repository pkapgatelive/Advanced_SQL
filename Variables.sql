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


Let's break down the components:

1. function_name: This is the name of the user-defined function.
2. parameters: These are the input parameters for the function.
3. return_type: This specifies the data type of the value that the function will return.
4. BEGIN...END: This block contains the logic of the function.
5. RETURN: This keyword is used to specify the value that the function will return.

- Here's a simple example of a user-defined function that calculates the square of a number:

CREATE FUNCTION square (x INT)
RETURNS INT
BEGIN
    RETURN x * x;
END;

You can then use this function in a SQL query:

SELECT square(5); -- Returns 25

- User-defined functions can be very useful for encapsulating logic, making code more modular, 
and facilitating code reuse. Keep in mind that the logic inside a user-defined function should be 
deterministic, meaning that for a given set of inputs, the function should always produce the same output. 
Additionally, user-defined functions are often less performant than built-in functions, so use them judiciously.

*/

Drop FUNCTION if EXISTS f_emp_avg_salary;

Create function f_emp_avg_salary (p_emp_no INTEGER) 
Returns Decimal (10,2)

DETERMINISTIC
NO SQL
READS SQL DATA

BEGIN

    Declare v_avg_salary Decimal(10,2);
    /*
    Got the Error: 
    1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to 
    your MySQL server version for the right syntax to use near '(p_emp_no, INTEGER) Returns Decimal (10,2)
    BEGIN
    Declare v_avg_salary Decim' at line 2
    
    This happend beacause of the MySQL Version, in this case, we need to decalre the following Keywords:

    -- Deterministic No Sql Reads Sql Data

    */

    Select avg(s.salary)
    into v_avg_salary
    from employees e Join Salaries s on e.emp_no = s.emp_no
    where e.emp_no = p_emp_no;

    Return v_avg_salary;
end;

-- We can not call the function we can select the indicated indicated values within parenthesis

Select f_emp_avg_salary(11300);


/*
Error Code: 1418.
Error Code: 1418. This function has none of DETERMINISTIC, NO SQL, or READS SQL DATA in its declaration and binary logging is enabled…



Let’s begin by saying that a log is a software component where you can save information about some events or errors that happened during the execution of a certain application. A log is preserved for traceability or debugging reasons and this is how it is used in MySQL as well.

Consequently, a Binary Log is a log that contains database changes. This type of logging affects the way in which we need to structure our code when creating MySQL functions.

When the Binary Log has been enabled, it will always check whether a function is changing the data in the database and what is the result to be produced. The situation can be described like this.

Unless we specify what the exact behavior of our function should be, our code will lead to an error. This error is with code 1418 and states that the function has none of the following characteristics in its declaration: DETERMINISTIC, NO SQL, or READS SQL DATA.

To solve this error, we must include one (or more) of these characteristics in our code in the way shown in the previous video. They must be placed right after we ‘ve specified the return type of the function. Here’s the syntax to use:

create function <function name> <function parameters> returns <type> <characteristics> …

Let’s check the meaning of these characteristics:

· DETERMINISTIC – it states that the function will always return identical result given the same input

· NO SQL – means that the code in our function does not contain SQL (rarely the case)

· READS SQL DATA – this is usually when a simple SELECT statement is present



When none of those is present in our code, MySQL assumes that our function is non deterministic and that it changes data. This might not be the case, but still, in the end, an error is raised just because MySQL cannot know a priori what our function will do. Adding one of those to our code will prevent this error of showing up.

That said, there is another way to stop the error - by disabling the binary log when creating functions. And we can achieve this by executing the following command:

SET @@global.log_bin_trust_function_creators := 1;

Technically speaking, this operation isn’t the safest one out there. Nevertheless, for the purposes of this course, it is the one that will solve the potential problems regardless of the version of MySQL.

In conclusion, remember that sometimes the Binary Log may be disabled anyway and you don’t have to take any of the above actions. In that case, we simply hope you’ve enjoyed reading this article! Thank you!
*/

