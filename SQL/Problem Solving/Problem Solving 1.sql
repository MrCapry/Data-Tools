
 -- Link for Below Tasks: https://www.w3resource.com/sql-exercises/joins-hr/index.php

SELECT job_id FROM employees
WHERE job_id IN
(SELECT e.job_id FROM employees e
group by e.job_id
HAVING count(distinct e.department_id)>1)
AND
job_id IN 
(SELECT job_id FROM employees 
group by job_id
having min(salary)>3000);


 -- Case in GROUP BY statement
SELECT 
   CASE WHEN sales_date>trunc(sysdate) THEN 'Future' ELSE 'Past' END as Period,
     SUM(sales_Units)
     FROM sales
     GROUP BY CASE WHEN sales_date>trunc(sysdate) THEN 'Future' ELSE 'Past' END;
     
     
           
 -- 1. From the following tables, write a SQL query to find the first name, last name, department number, and department name for each employee.    

SELECT e.first_name, e.last_name, d.department_id, d.department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;

-- 2. From the following tables, write a SQL query to find the first name, last name, department, city, and state province for each employee.

SELECT e.first_name, e.last_name, d.department_name, l.city,l.state_province
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
JOIN locations l
on d.location_id = l.location_id;


-- 3. From the following table, write a SQL query to find the first name, last name, salary, and job grade for all employees.
-- ფიქციური ამონახსნი
SELECT e.first_name, e.last_name, e.salary, j.grade
FROM employees e
JOIN grades g
ON e.salary BETWEEN g.min_slary and g.max_salary;

SELECT * FROM job_grade;



--4. From the following tables, write a SQL query to find all those employees who work in department ID 80 or 40. 
-- Return first name, last name, department number and department name.

SELECT e.first_name, e.last_name, e.department_id, d.department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id -- JOIN-შივე შეიძლება ამ პირობის ჩადება
WHERE e.department_id IN (40,80);


-- 5. From the following tables, write a SQL query to find those employees whose first name contains the letter ‘z’. 
 -- Return first name, last name, department, city, and state province.

SELECT e.first_name, e.last_name, d.department_name, l.city,l.state_province, l.Postal_Code
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
JOIN locations l
on d.location_id = l.location_id
WHERE e.first_name LIKE '%e%';

-- 6. From the following tables, write a SQL query to find all departments, including those without employees. 
 -- Return first name, last name, department ID, department name.

SELECT e.first_name, e.last_name, d.department_id, d.department_name
FROM employees e
RIGHT JOIN departments d
ON e.department_id = d.department_id;



-- 7. From the following table, write a SQL query to find the employees who earn less than the employee of ID 182. 
-- Return first name, last name and salary.

SELECT first_name, last_name, salary FROM employees
WHERE salary < (SELECT salary FROM employees WHERE employee_id = 182);


-- 8. From the following table, write a SQL query to find the employees and their managers. Return the first name of the employee and manager.
 -- SelfJoin Example

SELECT e.first_name, m.first_name
FROM employees e
JOIN employees m
ON e.manager_id = m.employee_id;


-- 9. From the following tables, write a SQL query to display the department name, city, and state province for each department.

SELECT d.department_name, l.city, l.state_province
FROM departments d
JOIN locations l
ON d.location_id = l.location_id;

-- 10. From the following tables, write a SQL query to find out which employees have or do not have a department. 
-- Return first name, last name, department ID, department name.

SELECT
e.first_name, e.last_name, e.department_id,d.department_name,
CASE WHEN d.department_id IS NULL then 'Not Have' ELSE 'Have' END AS "Department?"
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id;


 -- 11. From the following table, write a SQL query to find the employees and their managers. 
 -- Those managers do not work under any manager also appear in the list. Return the first name of the employee and manager.

SELECT e.first_name, m.first_name
FROM employees e
LEFT JOIN employees m
ON e.manager_id = m.employee_id;


--12. From the following tables, write a SQL query to find the employees who work in the same department as the employee with the last name Taylor. 
-- Return first name, last name and department ID.

SELECT first_name, last_name, department_id
FROM employees
WHERE department_id IN 
(SELECT department_id FROM employees
WHERE last_name = 'Taylor');


-- 13. From the following tables, write a SQL query to find all employees who joined on or after 1st January 1993 and on or before 31 August 1997. 
-- Return job title, department name, employee name, and joining date of the job.

SELECT e.first_name, e.last_name,e.hire_date,h.start_date, d.department_name,j.job_title
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
JOIN jobs j
ON e.job_id = j.job_id
JOIN job_history  h
ON e.employee_id = h.employee_id
WHERE h.Start_date BETWEEN '1Jan1993' AND '1AUG1997';


-- Hire_date და Start_date სხვადასხვა რაღაცაა იდეაში
SELECT e.employee_id, e.hire_date,j.start_date
FROM employees e
JOIN job_history j
ON e.employee_id = j.employee_id;

-- 14. From the following tables, write a SQL query to calculate the difference between the maximum salary of the job and the employee's salary. 
-- Return job title, employee name, and salary difference.

SELECT e.first_name, e.last_name, j.job_title, j.max_salary - salary AS Diff
FROM employees e
JOIN jobs j
ON e.job_id = j.job_id;

SELECT count(*), count(distinct job_id) FROM jobs;


--15. From the following table, write a SQL query to calculate the average salary, the number of employees receiving commissions in that department. 
-- Return department name, average salary and number of employees.

SELECT d.department_name, round(avg(salary),2) "Avg Salary", count(commission_pct)
FROM departments d
JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_name;

SELECT count(commission_pct) FROM employees;

-- 16. From the following tables, write a SQL query to calculate the difference between the maximum salary and the salary of all 
-- the employees who work in the department of ID 80. 
-- Return job title, employee name and salary difference.


SELECT 
e.first_name || ' ' || e.last_name, 
j.job_title,
j.max_salary - e.salary AS "Diff"
FROM employees e
JOIN jobs j
ON e.job_id = j.job_id
WHERE e.department_id=80;


-- 17. From the following table, write a SQL query to find the name of the country, city, and departments, which are running there.

SELECT c.country_name, l.city, d.department_name
FROM countries c
JOIN locations l
ON c.country_id = l.country_id
JOIN departments d
ON d.location_id = l.location_id;


-- 18. From the following tables, write a SQL query to find the department name and the full name (first and last name) of the manager.

SELECT d.department_name, e.first_name || ' ' || e.last_name AS "Manager Name" 
FROM departments d
JOIN employees e
ON d.manager_id = e.employee_id;


-- 19. From the following table, write a SQL query to calculate the average salary of employees for each job title.

SELECT j.job_title, round(avg(e.salary),1) as "Avg Salary"
FROM jobs j
JOIN employees e
ON j.job_id = e.job_id
GROUP BY j.job_title;


-- 20. From the following table, write a SQL query to find the employees who earn $12000 or more. 
-- Return employee ID, starting date, end date, job ID and department ID.

SELECT e.employee_id, j.start_date, j.end_date, e.department_id
FROM employees e
JOIN job_history j
ON e.employee_id = j.employee_id
WHERE e.salary>=12000;


   
-- 21. From the following tables, write a SQL query to find out which departments have at least two employees.
-- Group the result set on country name and city. Return country name, city, and number.


SELECT department_id, count(employee_id) FROM employees
GROUP by department_id
Having count(employee_id)>1;

SELECT c.country_name, l.city, COUNT(DISTINCT e.department_id)
FROM countries c
JOIN locations l
ON c.country_id = l.country_id
JOIN departments d
ON l.location_id = d.location_id
JOIN employees e
ON  d.department_id = e.department_id
WHERE e.department_id IN 
    (SELECT department_id FROM employees
    GROUP by department_id
    Having count(employee_id)>1)
    GROUP BY  c.country_name, l.city;


-- 22. write a SQL query to find the department name, full name (first and last name) of the manager and their city.


SELECT d.department_name, e.first_name ||' '|| e.last_name AS "Manager Name", l.city
FROM departments d
JOIN locations l
ON d.location_id = l.location_id
JOIN employees e
ON d.manager_id = e.employee_id;

-- 23. Write a SQL query to calculate the number of days worked by employees in a department of ID 80. 
-- Return employee ID, job title, number of days worked.

SELECT * FROM job_history;


SELECT h.employee_id, j.job_title,h.end_date-h.s
tart_date AS "Total Days"
FROM job_history h
JOIN jobs j 
ON h.job_id = j.job_id; 


-- 24. Write a SQL query to find full name (first and last name), and salary of all employees working 
-- in any department in the city of London

SELECT e.first_name || ' '|| e.last_name, e.salary 
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
JOIN locations l
ON d.location_id = l.location_id
WHERE l.city='London';

SELECT 
first_name || ' ' || last_name FULL_Name,
salary FROM employees
WHERE department_id IN 
  (SELECT department_id FROM departments
   WHERE location_id IN 
    (SELECT location_id FROM locations
     WHERE city = 'London')
    );


-- 25. Write a SQL query to find full name (first and last name), job title, start and end date

SELECT 
e.first_name || ' '|| e.last_name AS "Full Name",
j.job_title, h.start_date,h.end_date, e.employee_id
FROM employees e
JOIN Job_history h
ON e.employee_id = h.employee_id
JOIN jobs j
ON h.job_id = j.job_id
WHERE e.commission_pct IS NULL;


SELECT k.*,k.order_date AS "Sc" FROM sales k; -- Correct way
SELECT *,order_date as "Sc" FROM sales; -- Incorrect way



-- 26. Write a SQL query to find the department name, department ID, and number of employees in each department.

SELECT d.department_name, d.department_id, count(e.employee_id) AS "Total Employees" 
FROM departments d
JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_name, d.department_id;

-- Second Way (but it is not as efficienct as firt one)

SELECT d.department_name, d.department_id, e.Counting
FROM departments d
JOIN 
(SELECT department_id, count(employee_id) as Counting
FROM employees
GROUP BY department_id) e
ON d.department_id = e.department_id;

-- Thid Way

SELECT 
d.department_name,
d.department_id,
(SELECT count(employee_id) FROM employees
WHERE department_id = d.department_id)
FROM departments d;



-- 27. Write a SQL query to find out the full name (first and last name) of the employee 
-- with an ID and the name of the country where he/she is currently employed.

SELECT
e.first_name || ' ' || e.last_name,
e.employee_id, c.country_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
JOIN locations l
ON d.location_id = l.location_id
JOIN countries c
ON l.country_id = c.country_id;


SELECT * FROM job_history
WHERE department_ID NOT BETWEEN 20 AND 50;




