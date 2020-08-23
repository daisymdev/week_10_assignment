-- Write 5 stored procedures for the employees database.
-- Write a description of what each stored procedure does and how to use it.
-- Procedures should use constructs you learned about from your research assignment and be more than just queries.

-- This procedure pulls the latest 25 employee's hire date
DELIMITER ##
CREATE PROCEDURE get_hire_date()
BEGIN
SELECT hire_date FROM employees ORDER BY hire_date DESC LIMIT 25;
END##

DELIMITER ;
CALL get_hire_date();
DROP PROCEDURE get_hire_date;

-- This procedure will insert new employee data to titles table
DELIMITER ##
CREATE PROCEDURE add_new_title(
   p_emp_no INT,
   p_title VARCHAR(50),
   p_to_date DATE)
BEGIN
INSERT INTO titles (emp_no, title, from_date, to_date) VALUES (p_emp_no, p_title, CURDATE(), p_to_date);
END##

DELIMITER ;
CALL add_new_title(10001, 'software developer', NULL);
SELECT * FROM titles WHERE emp_no=10001;

-- This procedure will show employee information for salaries that are above 50,000
DELIMITER ##
CREATE PROCEDURE employee_info_salary_above(salary_input INT)
BEGIN
SELECT CONCAT('$', FORMAT(s.salary,2)) AS 'Salary', CONCAT(e.first_name,' ', e.last_name) AS 'Full Name', e.hire_date AS 'Start Date'
FROM salaries s
JOIN employees e
ON e.emp_no = s.emp_no
WHERE salary_input <= s.salary
LIMIT 25;
END##

DELIMITER ;
CALL employee_info_salary_above(50000);
DROP PROCEDURE employee_info_salary_above;

-- This procedure will analyze Finance department employees, and if employees have been there for a certain number of days, then we will raise salary by $5,000
--dept table, employees table, salary table, current_dept_emp table <- finding which tables to join
DELIMITER ##
CREATE PROCEDURE dept_raise(p_dept_name VARCHAR(40), p_employment_time INT, raise INT)
BEGIN

UPDATE salaries s
JOIN employees e
ON e.emp_no = s.emp_no
JOIN current_dept_emp c
ON e.emp_no = c.emp_no
JOIN departments d
ON c.dept_no = d.dept_no
SET salary = salary + raise
WHERE p_employment_time < DATEDIFF(CURDATE(), hire_date)
AND dept_name = p_dept_name;
END##

DELIMITER ;
DROP PROCEDURE dept_raise;
CALL dept_raise('Marketing', 365, 5000);

SELECT * FROM salaries s
JOIN employees e
ON e.emp_no = s.emp_no
JOIN current_dept_emp c
ON e.emp_no = c.emp_no
JOIN departments d
ON c.dept_no = d.dept_no
WHERE dept_name = 'Marketing' LIMIT 5;

SELECT DATEDIFF(CURDATE(), '1993-08-03');
--20200822
--19930803
--20198829

-- This procedure will check if emp_no is greater than 1000, if so, it will change last name to 'Blue'
DELIMITER ##

CREATE PROCEDURE change_last_name(
IN  p_emp_no INT,
OUT p_last_name VARCHAR(20))
BEGIN
DECLARE employee INT;

SELECT emp_no
INTO employee
FROM employees
WHERE last_name = p_last_name;

IF employee > 1000 THEN
SET p_last_name = 'Blue';
END IF;
END ##
DELIMITER ;
CALL change_last_name(1001, @lastname);

DROP PROCEDURE change_last_name;
