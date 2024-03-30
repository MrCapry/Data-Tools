
-- SubQueries
-- Inner Queries are executed fist
-- Single row subquery, multiple-row subquery, multiple-column subquery


-- can be used SELECT,FROM,WHERE, having clauses
SELECT salary FROM employees
WHERE employee_id = 145;

SELECT * FROM employees
WHERE salary > 
(SELECT salary FROM employees
WHERE employee_id = 145)
ORDER BY salary ASC;

-- Single row subquery
-- >,<,=,<>, etc...

SELECT * FROM employees
WHERE department_id = 
(SELECT department_id FROM employees
WHERE employee_id = 145)
AND salary <
(SELECT Salary FROM employees
WHERE employee_id = 145);

-- hired first

SELECT * FROM employees
WHERE hire_date = 
(SELECT min(hire_date) FROM employees);

-- if single row return multiple row, it return error
-- if null is returned in subqery, comarpirosn might return also null
-- Logical Error for single-row subqery

 -- Multiple Rows
SELECT * FROM employees
WHERE hire_date = 
(SELECT min(hire_date) FROM employees
group by department_id);


SELECT * FROM employees
WHERE department_id = 
(SELECT department_id FROM employees
WHERE employee_id  = 178); -- it returns NULL;

-- Multipel row subqueries
-- not used in FROM clause
-- IN, ANY, ALL

-- matches any values
-- matches at least one value
-- matches all values

-- can be used FROM, WHERE, having. not in SELECT

SELECT * FROM employees
WHERE salary IN (14000,15000,10000);


SELECT * FROM employees
WHERE salary in 
(SELECT min(salary) FROM employees
group by department_id);


-- <ANY, less than maximum
-- =ANY, sames as IN
-- >ANY, more than minimum


SELECT salary FROM employees
WHERE job_id = 'SA_MAN';

SELECT * FROM employees
WHERE salary = ANY
(SELECT salary FROM employees
WHERE job_id = 'SA_MAN');


SELECT * FROM employees
WHERE salary > ANY
(SELECT salary FROM employees
WHERE job_id = 'SA_MAN');

SELECT * FROM employees
WHERE salary < ANY
(SELECT salary FROM employees
WHERE job_id = 'SA_MAN');

-- All

-- <ALL, less than minimum
-- =ALL, means nothing, it is absurd
-- >ALL, more than maximum

 
SELECT * FROM employees
WHERE salary > ALL
(SELECT salary FROM employees
WHERE job_id = 'SA_MAN');

SELECT * FROM employees
WHERE salary < ALL
(SELECT salary FROM employees
WHERE job_id = 'SA_MAN');


SELECT * FROM employees
WHERE salary = ALL
(SELECT salary FROM employees
WHERE job_id = 'SA_MAN');


-- retrun all employees who works in United Kingdom
-- if only one row is returned, = is better than IN
SELECT * FROM employees
WHERE department_id IN
  (SELECT department_id
  FROM departments
  WHERE location_id IN
    (SELECT location_id
    FROM locations
    WHERE country_id IN
      (SELECT country_id 
      FROM countries
      WHERE country_name = 'United Kingdom')));


-- Multiple column subqueries
    -- NonPairwise comaprison
    -- Pairwise comparison
 
 
 -- NonPairwise example
SELECT * FROM employees
WHERE department_id IN
(SELECT department_id FROM employees
WHERE employee_id IN (103,105,110))
AND salary IN 
(SELECT salary FROM employees
WHERE employee_id IN (103,105,110));


-- PairWise
 
-- use as many rows as you with, 2+. order should be same

SELECT * FROM employees
WHERE (department_id, salary) IN
(SELECT department_id, salary FROM employees
WHERE employee_id IN (103,105,110));
   

-- show employees who earns the most in their department

-- Incorrect versions

-- NULL

SELECT * FROM employees
WHERE department_id IN
(SELECT department_id FROM employees)
AND salary in
(SELECT max(salary) FROM employees
group by department_id);


SELECT * FROM employees
WHERE department_id IN -- NULL
(SELECT department_id FROM employees);


-- correct versions
SELECT * FROM employees
WHERE (department_id, salary) IN
(SELECT department_id, max(salary)
FROM employees
group by department_id)
ORDER BY salary;

-- Another Version
SELECT * FROM employees e
WHERE salary = (SELECT max(salary) FROM employees
                WHERE department_id = e.department_id);


-- Unique departments
SELECT count( distinct department_id) FROM employees;

-- Employees who reached maximum salary of their job

SELECT * FROM employees
WHERE (job_id, salary) IN
(SELECT job_id, max_salary FROM jobs);

-- if multple column query return one row, it is single-row subqery (just by definition)

-- Using subquery as table (Inline views)

SELECT * FROM 
    (SELECT state_province, city, department_id, department_name
    FROM departments JOIN locations USING (Location_Id));

-- Simple inline view

SELECT 
department_name,
location_id FROM
  (SELECT department_id, department_name,location_id FROM departments)
  ORDER BY location_id DESC;

SELECT 
e.employee_id,
e.first_name,
e.last_name,
a.city
FROM employees e
JOIN
  (SELECT department_id, department_name,city,state_province
   FROM departments JOIN locations
   using(location_id)) a
  ON e.department_id = a.department_id;

-- Scalar Subqueries (only one row/column, doesn't matter string or number or date)

SELECT (SELECT sysdate FROM dual) FROM dual; -- მოსულა
SELECT (SELECT sysdate FROM sales) FROM sales; -- არ მოსულა
SELECT (SELECT sysdate FROM dual) FROM sales; -- მოსულა
SELECT * FROM dual; -- Dummy data with 1 row only


SELECT * FROM employees
WHERE department_id = 
(SELECT department_id FROM employees WHERE upper(first_name) = 'LUIS'); -- Case-sensitivity

  
SELECT 
(SELECT max(hire_date) FROM employees) AS Max_hire
 FROM employees;

SELECT * FROM employees
WHERE salary>
(SELECT avg(salary) FROM employees);


SELECT * FROM employees
WHERE department_id = 
(SELECT department_id FROM employees
WHERE first_name = 'Luis');


-- Scalr subquery in case expression
SELECT 
first_name,
last_name, 
employee_id,
(case
      WHEN location_id = (SELECT location_id FROM locations WHERE postal_code = '99236') 
        THEN 'San Francisco' ELSE 'Other' END) AS "City"
FROM employees
NATURAL JOIN -- Manager_id as well as department_id
departments;



-- scalars can be used: SELECT, decode, WHERE, set (update), values(insert), ORDER BY
-- return nothing if scalar subqery is NULL or 0 or when it returns multiple rows(error)

-- returns nothing, Luises doesn't exist
SELECT * FROM employees
WHERE department_id = 
(SELECT department_id FROM employees
WHERE first_name = 'Luises');

SELECT * FROM employees
WHERE (department_id, manager_id) = 
(SELECT department_id, manager_id FROM employees
WHERE first_name = 'Luis');

-- boths are same becuase it return one row
SELECT * FROM employees
WHERE (department_id, manager_id) IN 
(SELECT department_id, manager_id FROM employees
WHERE first_name = 'Luis');

   -- Diffrence between scalar subqery and single row subqery
-- scalarSub query return only one row and one column
-- but singleRow subquery might return multiple columns


-- correlated SubQueries
-- <,>,etc..  IN,ANY,ALL

-- Row by row processing

SELECT first_name, last_name, employee_id, department_id,salary
FROM employees a
WHERE salary = (Select max(salary)
               FROM employees b
               WHERE b.department_id = a.department_id)
ORDER BY salary desc;


SELECT first_name, last_name, employee_id, department_id,max(salary)
FROM employees
group by first_name,last_name, employee_id, department_id
ORDER BY max(salary);


SELECT first_name, last_name, employee_id, department_id,salary 
FROM employees
WHERE (department_id,salary) IN (SELECT department_id, max(salary) 
                              FROM employees
                              group by department_id)
ORDER BY salary desc;


SELECT first_name, last_name, employee_id, department_id,salary
FROM employees a
WHERE salary < (SELECT avg(salary)
               FROM employees b
               WHERE b.department_id = a.department_id)
ORDER BY salary desc;

-- Using SELECT statment for Joining
SELECT department_id,round(avg(salary),2) as avg_sal
FROM employees
group by department_id
ORDER BY avg_sal;

-- Pretty interesting techniques used

SELECT employee_id, first_name, last_name, a.department_id,salary
FROM employees a
JOIN 
    (SELECT department_id,round(avg(salary),2) avg_sal
    FROM employees
    group by department_id) b
ON (a.department_id = b.department_id)
WHERE a.salary<b.avg_sal
ORDER BY a.salary DESC;

-- In most cases fastest (DESC) : Mult Col, Join, Corr Sub

-- showing employees and average salary in their deparment

-- Correlated SubQuery soltion
  -- Correlated scalar subquery examples:

SELECT
employee_id,
first_name,
last_name, 
department_name,
salary,
   (SELECT round(avg(salary),1) FROM employees k
          WHERE department_id = e.department_id) AS "Avg Salary" 
FROM employees e               
JOIN departments d -- it is outer query (row by row)
ON e.department_id = d.department_id
ORDER BY "Avg Salary" DESC;


SELECT
employee_id,
first_name,
last_name, 
department_name,
salary,
   (SELECT round(avg(salary),1) FROM employees k
          WHERE department_id = d.department_id) AS "Avg Salary"
FROM employees e                
JOIN departments d 
ON e.department_id = d.department_id
WHERE (SELECT round(avg(salary),1) FROM employees k
          WHERE department_id = d.department_id)>10000 
-- WHERE "Avg Salary" > 10000 
ORDER BY "Avg Salary" DESC;



-- Solution Using Partition Over
SELECT 
employee_id,
first_name,
last_name,
department_name,
e.department_id,
Salary, 
round(avg(salary) OVER (partition by e.department_id) ,1) AS "Avg Salary"
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
ORDER BY "Avg Salary" DESC;



SELECT department_id, round(avg(salary),1) as "avg"
FROM employees
group by department_id
ORDER BY department_id asc;



-- each customers sales quantity

SELECT name, count(sales_date) as "Purchase #" 
FROM customers c
LEFT JOIN sales s 
ON c.customer_id = s.customer_id
group by name
ORDER BY "Purchase #" desc;


SELECT name, count(*) as "Purchase #" 
FROM sales s
JOIN customers c
ON s.customer_id = c.customer_id
group by name
ORDER BY "Purchase #" desc;

SELECT name,
       (SELECT Count(*) FROM sales s
       WHERE s.customer_id = c.customer_id) AS "Purchase #"
       FROM customers c -- Outer Query
       ORDER BY "Purchase #" desc;
       

-- Exists oprators and semiJoins


SELECT employee_id, first_name, last_name, department_id
FROM employees a
WHERE exists 
      (SELECT * 
      FROM employees
      WHERE manager_id = a.employee_id); 
     
-- NOT EXISTS


-- Select department which doesn't have employee
SELECT department_name, department_id
FROM departments d
WHERE NOT EXISTS 
          (SELECT * FROM employees
          WHERE department_id = d.department_id);

-- NOT IN and NOT EXISTS is same, except WHERE is NULL, NOT IN for NULL returns nothing (important Note)
SELECT department_name, department_id
FROM departments 
WHERE department_id NOT IN
          (SELECT department_id FROM employees); 






