﻿
-- Remaining Joins
-- if don't specify join type, corssJoin might happen

SELECT * FROM sales;
SELECT * FROM customers;


SELECT * FROM employees
CROSS JOIN departments;

-- X*Y*Z
SELECT * FROM employees
CROSS JOIN departments
CROSS JOIN jobs;


SELECT
e.first_name,
e.last_name,
e.department_id,
d.department_id,
d.department_name
FROM employees e
CROSS JOIN departments d
WHERE e.last_name ='King' AND e.first_name = 'Steven';


-- if don't specify, Old Syntax
   -- CROSS JOIN with Old Syntax
SELECT * FROM employees, departments;

-- Counting Employees by department_name and Job_title
-- Expanded Table

SELECT
d.department_name,
j.job_title,
Count(*) AS "Total Employees"
FROM employees e 
JOIN departments d
ON (e.department_id = d.department_id)
JOIN jobs j
ON (j.job_id = e.job_id)
GROUP BY 
d.department_name,
j.job_title
ORDER BY "Total Employees" DESC;


-- I need to identify WHERE I need more employees

SELECT 
c.department_name,
c.job_title,
Count(e.employee_id) AS "Total Employees"
FROM
  (SELECT d.department_name, j.job_title, j.job_id, d.department_Id
   FROM departments d CROSS JOIN jobs j ) c
LEFT JOIN employees e 
ON (e.job_id = c.job_id AND e.department_id = c.department_id)
GROUP BY  c.department_name,c.job_title
ORDER BY "Total Employees" ASC,c.department_name, c.job_title;


-- Cross Join Result

SELECT d.department_name, j.job_title, j.job_id, d.department_Id
FROM departments d CROSS JOIN jobs j
ORDER BY d.department_name; 


-- Old style Join Sytnaxes (Non-ANSI Joins)

-- Inner, Equijoin example

SELECT
e.first_name,
e.last_name,
d.department_name
FROM employees e , departments d
WHERE e.department_id = d.department_id
AND d.department_name = 'Finance';


SELECT
e.first_name,
e.last_name,
d.department_name,
l.city,
l.street_address
FROM employees e , departments d, locations l
WHERE e.department_id = d.department_id
AND d.location_id  = l.location_id
AND d.department_name = 'Finance';

SELECT e.first_name, e.last_name, d.department_name
FROM employees e LEFT JOIN departments d
ON (e.department_id = d.department_id);

SELECT e.first_name, e.last_name, d.department_name
FROM employees e,departments d
WHERE e.department_id = d.department_id(+);

-- Right JOIN

SELECT e.first_name, e.last_name, d.department_name
FROM employees e,departments d
WHERE e.department_id(+) = d.department_id;

-- FULL Join

SELECT e.first_name, e.last_name, d.department_name
FROM employees e FULL JOIN departments d
ON (e.department_id = d.department_id);


SELECT e.first_name, e.last_name, d.department_name
FROM employees e,departments d
WHERE e.department_id(+) = d.department_id
UNION 
SELECT e.first_name, e.last_name, d.department_name
FROM employees e,departments d
WHERE e.department_id = d.department_id(+);


-- (+) is FROM WHERE I want to see NULL results

-- Repeating

-- New 1
SELECT * FROM sales s
JOIN customers c
ON s.customer_id = c.customer_id;
-- Old 1
SELECT * FROM sales s,customers c
WHERE s.customer_id = c.customer_id;

-- New 2

SELECT first_name, last_name, department_name, e.department_id, d.department_id, location_id
FROM employees e 
RIGHT JOIN departments d
ON e.department_id = d.department_id
RIGHT JOIN locations
USING(location_id); 

-- Old 2 
SELECT first_name, last_name, department_name, e.department_id, d.department_id, l.location_id
FROM employees e, departments d, locations l
WHERE e.department_id(+) = d.department_id
AND d.location_id(+) = l.location_id;


-- New 3
SELECT * FROM employees e 
FULL JOIN departments d
ON e.department_id = d.department_id;
-- Old 3 (Incorrect old Full Syntax) - (Correct one is with Union)
SELECT * FROM employees e,departments d 
WHERE e.department_id(+) = d.department_id(+);


-- New 4
SELECT first_name, last_name, department_name, e.department_id,d.department_id,location_id
FROM employees e
RIGHT JOIN departments d
ON e.department_id = d.department_id
RIGHT JOIN locations
USING (location_id);

-- Old 4

SELECT 
  first_name,
  last_name,
  department_name,
  e.department_id,
  d.department_id,
  l.location_id
FROM  
  employees e,
  departments d,
  locations l
WHERE   e.department_id(+)  = d.department_id
AND d.location_id(+) = l.location_id;


SELECT
location_id,
(CASE 
       WHEN location_id IN (SELECT distinct(location_id) FROM jobs) THEN 1 
         ELSE 0 END) 
FROM departments; -- Checker

-- New 5
SELECT first_name, last_name, department_name, job_title
FROM employees e 
RIGHT JOIN departments d
ON e.department_id = d.department_id
RIGHT JOIN jobs j
USING(job_id);

-- Old 5 (Return Error) - might be updated for old syntax
-- One table should not be optional table in two join (employees in this example)
SELECT first_name, last_name, department_name,e.department_id,d.department_id,j. job_title,e.job_id
FROM employees e ,departments d, jobs j
WHERE e.department_id(+) = d.department_id
AND e.job_id(+) = j.job_id;


-- Correct version will be  (Using Subqeuery)

SELECT first_name, last_name, department_name,ed.job_id,j.job_title, j.job_id
FROM (SELECT first_name, last_name, job_id, department_name
             FROM employees e, departments d
             WHERE e.department_id(+) = d.department_id) ed, jobs j
             WHERE ed.job_id(+) = j.job_id;


-- Another Example

SELECT d.department_name, e.first_name, e.department_id, d.department_id, e.salary
FROM departments d, employees e
WHERE d.department_id = e.department_id(+)
AND d.department_id>=40
AND e.salary(+)>=5000
ORDER BY d.department_name,e.first_name;


SELECT d.department_name, e.first_name, e.department_id, d.department_id, e.salary
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id AND e.salary>=5000
WHERE d.department_id>=40
ORDER BY d.department_name,e.first_name;


-- Diffrences between Joins

-- Inner equijoin example
-- All Joins should have equal sign
SELECT e.first_name, e.last_name, d.department_name
FROM employees e 
JOIN departments d
ON (e.department_id = d.department_id);

SELECT e.first_name, e.last_name, d.department_name
FROM employees e JOIN departments d
ON (e.department_id = d.department_id
    AND e.manager_id = d.manager_id);

SELECT e.first_name, e.last_name, d.department_name, city
FROM employees e JOIN departments d
ON (e.department_id = d.department_id)
JOIN locations l
ON (d.location_id = l.location_id);

SELECT e.first_name, e.last_name, d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id;


-- Inner non-equijoin

SELECT e.first_name, e.last_name, j.job_title, e.salary, j.min_salary, j.max_salary,e.job_id,j.job_id
FROM employees e JOIN jobs j
ON (e.job_id = j.job_id AND e.salary > j.min_salary)
ORDER BY e.salary DESC;

-- With Old Syntax
SELECT e.first_name, e.last_name, j.job_title, e.salary, j.min_salary, j.max_salary
FROM employees e, jobs j
WHERE e.job_id = j.job_id AND e.salary > j.min_salary;

-- Outer Equijoin
SELECT first_name, last_name, department_name, e.department_id emp_dept_id, d.department_id dep_dept_id
FROM employees e RIGHT OUTER JOIN departments d
ON(e.department_id = d.department_id);


SELECT first_name, last_name, department_name, e.department_id emp_dept_id, d.department_id dep_dept_id
FROM employees e, departments d
WHERE e.department_id(+) = d.department_id;

SELECT first_name, last_name, department_name, e.department_id, d.department_id, location_id
FROM employees e RIGHT OUTER JOIN departments d
ON(e.department_id = d.department_id)
RIGHT OUTER JOIN locations l
USING(location_id);


-- Outer Non-Equijoin examples

SELECT e.job_id, j.job_id, e.first_name, e.last_name, j.job_title, e.salary, j.min_salary, j.max_salary
FROM employees e LEFT OUTER JOIN jobs j 
ON e.job_id = j.job_id
AND e.salary BETWEEN j.min_salary+500 AND j.max_salary;

SELECT e.job_id, j.job_id, e.first_name, e.last_name, j.job_title, e.salary, j.min_salary, j.max_salary 
FROM employees e, jobs j 
WHERE e.job_id = j.job_id(+) 
AND e.salary BETWEEN j.min_salary(+)+500 AND j.max_salary(+); 


-- Which join type you should use

-- don't use old syntax
-- don't use natural join
-- use table aliases

-- Entity relationship models
-- One to many, many to one
-- One to one
-- Many to many

 




