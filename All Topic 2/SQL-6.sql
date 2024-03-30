﻿-- Joining multiple tables

Select * FROM sales;
SELECT * FROM customers;
Select * FROM territory;
SELECT * FROM money;

-- Case sensitive retrieveing when space in column name
 

SELECT * FROM user_Tables;
SELECT 
"GAME NAME",
"GAME GENRE" FROM games;


-- Simple Joining
SELECT a.game_id,b.price,b.cost FROM sales a
JOIN  money b ON
a.game_id = b.game_id;

-- have department_id in common
-- process of normalization, key column because of joining, low space

-- Join types: 
-- Natural - same name and same data type columns, if same name but different data type, it returns error
-- Inner 
-- Outer (Left outer, right outer, full outer)
-- Equijoin
-- Non-equijoin
-- self join
-- cross join

SELECT * FROM employees;
SELECT * FROM departments;


-- Natural Join, can't have alias

SELECT 
sales_date,
order_date,
game_id,
price,
cost,
sales_units*price AS "Revenue",
sales_units*cost AS "Cost"
FROM sales
NATURAL JOIN
money;


-- Common columns are returned first, then source and last target table
-- if not exact match, nothing is returned

SELECT * FROM employees
NATURAL JOIN
departments;

SELECT * FROM departments
NATURAL JOIN
employees;

SELECT 
first_name,
last_name,
Hire_date,
Job_id 
FROM departments
NATURAL JOIN
employees;
-- When many to many, all matching is returend

SELECT 
e.first_name,
e.last_name,
e.Hire_date,
e.Job_id,
d.department_name,
manager_id
FROM departments d
NATURAL JOIN
employees e;


SELECT distinct * FROM departments;
SELECT distinct manager_id,location_id FROM departments; 


-- Using Clause

SELECT * FROM employees
JOIN departments
USING (department_id);

-- Same as Natural Join, but exacting which columns to be same (Equijoin)

SELECT * FROM employees
JOIN departments
USING (department_id,manager_id);

-- Handling ambiguous column names

SELECT * FROM employees;
SELECT * FROM departments;

-- Column ambiguous, when there is same column whihc I SELECT in both table

SELECT
first_name,
last_name,
e.manager_id,
d.manager_id,
d.department_name,
department_id
FROM employees e
JOIN departments d
USING (department_id);

-- Inner Join, Only common rows
-- Can say INNER JOIN or JOIN
-- Can say Using or ON
-- ON (Join Condition), Using(Column_names)

SELECT * FROM customers;
SELECT DISTINCT(customer_id) FROM sales;

-- Starter Checking
SELECT distinct(customer_id) FROM
(SELECT
s.customer_id,
c.customer_id AS "Cust_Id", 
c.gender
FROM sales s
INNER JOIN customers c
ON s.customer_id = c.customer_id);

-- same as creating as primary Key (Departmend_id and Manager_id)
SELECT 
e.first_name,
e.last_name,
d.manager_id,
d.department_name,
e.department_id
FROM employees e JOIN departments d
ON (e.department_id = d.department_id AND e.manager_id = d.manager_id); 

SELECT
e.first_name,
e.last_name,
manager_id "Mag_id",
d.department_name,
department_id "Dep_Id"
FROM employees e JOIN departments d 
USING (department_id, manager_id);


SELECT
e.employee_id,
e.first_name || ' ' || e.last_name AS "Employee",
d.first_name || ' ' || d.last_name AS "Manager"
FROM employees e
JOIN employees d
ON e.Manager_id = d.employee_id
WHERE e.first_name='Neena';


-- Multiple Join Operations

SELECT * FROM sales;
SELECT * FROM customers;
SELECT * FROM territory;

-- Multiple Join's Example

SELECT
last_day(s.sales_date) AS "Eom",
c.name,
c.country,
t.continent,
SUM(sales_units) AS "Units Sold"
FROM sales s
JOIN customers c
ON s.customer_id = c.customer_id
JOIN territory t
ON c.country = t.country
GROUP BY 
last_day(s.sales_date),
c.name,
c.country,
t.continent
ORDER BY last_day(s.sales_date);


SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM locations;

SELECT 
first_name, last_name, d.department_name,
l.city,l.postal_code,l.street_address
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
JOIN locations l
ON l.location_id = d.location_id;

-- ON, Using, Natural Join can be used in same query

-- ON and USING example

SELECT
first_name, last_name, d.department_name,
l.city,l.postal_code,l.street_address
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
JOIN locations l
USING (location_id);

-- ON, Using, NATURAL JOIN

SELECT
first_name, last_name, d.department_name,
l.city,l.postal_code,l.street_address
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
JOIN locations l
USING (location_id)
NATURAL JOIN countries;

