﻿
-- Every Join operation is Like Expanded Table
-- When Joinin 3rd table, it looks expanded table of 1st and 2nd tables

-- Natural might cause CrossJoin
-- Restricting JOINs
-- Also what columns you mention in SELECT is important while Joining  


-- 4 Connected Tables
SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM locations;
SELECT * FROM countries;

-- Example of Join
SELECT
e.first_name || ' '  || e.last_name,
e.hire_date,
round(e.salary,0) AS "Salary",
d.department_name,
l.city,
l.state_province "State or Province",
c.country_name "Country"
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
JOIN locations l
ON l.location_id = d.location_id
JOIN countries c
ON c.country_id = l.country_id;



SELECT * from sales;
SELECT * from games;

-- restrincting
-- Can be restricted with any column which are used in Join Condition table (not only SELECTed columns)

SELECT
  g.GAME_NAME,
  g.GAME_GENRE,
  last_day(s.sales_date) AS "EOM",
  SUM(s.sales_units) AS "Units Sold"
  FROM sales s
  JOIN games g
  ON s.game_id = g.game_id
  WHERE 1=1
  AND s.Order_date>'31DEC2020'
  AND g.GAME_NAME = 'Mario'
  GROUP BY 
  g.GAME_NAME,
  g.GAME_GENRE,
  last_day(s.sales_date)
  ORDER BY last_day(s.sales_date) DESC,"Units Sold";


-- You can't write WHERE clause more than once
SELECT * from sales s
JOIN customers c
ON s.customer_id = c.customer_id
AND c.country='Iran'
AND s.sales_date BETWEEN '1JAN2020' AND '1DEC2023'; 

-- Self Joins
-- For Hierarchical Data

SELECT * from employees;
-- Logical Example

SELECT
e.employee_id,
e.first_name || ' ' || e.last_name,
e.salary "Employee Salary",
m.manager_id,
m.first_name || ' ' || m.last_name,
m.salary,
m.salary - e.salary AS "Salary Diff"
FROM employees e
JOIN employees m
ON e.manager_id = m.employee_id
ORDER BY "Salary Diff" DESC;


SELECT
e.employee_id,
e.first_name || ' ' || e.last_name,
e.salary "Employee Salary",
m.manager_id,
m.first_name || ' ' || m.last_name,
m.salary,
m.salary - e.salary AS "Salary Diff"
FROM employees e
JOIN employees m
ON e.employee_id= m.manager_id
ORDER BY e.employee_id ASC; 



-- Non-Equijoins
SELECT * from employees;

SELECT * from jobs
ORDER BY Max_salary DESC;


SELECT
job_id,
max(salary) AS "Max Salary",
min(salary) AS "Min Salary"
from employees
GROUP BY job_id
ORDER BY "Max Salary" DESC;
 

-- Non-Equijoin examples
-- <,>,<>,=,!=, Between etc.
 
 
SELECT
e.first_name || ' ' || e.last_name,
e.job_id,
e.salary,
j.job_id,
j.min_salary,
j.max_salary
FROM employees e
JOIN jobs j
ON (e.salary>=j.min_salary AND e.salary<=j.MAX_salary)
WHERE e.job_id = 'AD_PRES';

SELECT
e.first_name || ' ' || e.last_name,
e.job_id,
e.salary,
j.job_id,
j.min_salary,
j.max_salary
FROM employees e
JOIN jobs j
ON e.salary BETWEEN j.min_salary AND j.max_salary
WHERE e.job_id = 'AD_PRES';


SELECT
e.first_name || ' ' || e.last_name,
e.job_id,
e.salary,
j.job_id,
j.min_salary,
j.max_salary
FROM employees e
JOIN jobs j
ON e.salary>=j.min_salary
WHERE e.job_id = 'AD_PRES';


SELECT
e.first_name || ' ' || e.last_name,
e.job_id,
e.salary,
j.job_id,
j.min_salary,
j.max_salary,
CASE WHEN e.salary>=j.min_salary THEN 1 ELSE 0 END Checker-- all rewos returns 1
FROM employees e
JOIN jobs j
ON e.salary>=j.min_salary
ORDER BY checker ASC; 


-- Uneqaulity checker (SQL) (Salary doesn't match)

SELECT
e.first_name || ' ' || e.last_name,
e.job_id,
e.salary,
j.job_id,
j.min_salary,
j.max_salary
FROM employees e
JOIN jobs j
ON (e.salary>=j.max_salary AND e.job_id = j.job_id);


SELECT
e.first_name || ' ' || e.last_name,
e.job_id,
round(e.salary,0) AS "Salary",
j.job_id,
j.min_salary,
j.max_salary
FROM employees e
JOIN jobs j
ON e.salary>=j.max_salary 
WHERE j.job_id = 'IT_PROG';


-- Another usage is finding duplicates

           -- Task: Find employees whose names are the same

SELECT
e.first_name || ' ' || e.last_name,
s.first_name || ' ' || s.last_name
FROM employees e
JOIN employees s
ON (e.first_name = s.first_name AND e.employee_id<>s.employee_id) 
ORDER BY e.first_name ASC;



SELECT
e.first_name || ' ' || e.last_name,
s.first_name || ' ' || s.last_name
FROM employees e
JOIN employees s
ON e.employee_id<>s.employee_id
AND e.first_name = s.first_name
ORDER BY e.first_name ASC; 


SELECT
e.employee_id,
e.first_name,
e.last_name,
s.first_name  || ' ' || s.last_name
FROM employees e
JOIN employees s
ON e.employee_id<>s.employee_id
AND e.last_name = s.last_name
ORDER BY e.first_name ASC;



-- Calculate running total of certain columns

SELECT
sales_date,
order_date,
extract(month FROM sales_date),
extract(day FROM sales_date),
extract(year FROM sales_date),
extract(day from last_day(sales_date)) as "Last Day"
FROM sales;

SELECT * from payouts;

SELECT * from payouts
WHERE employee_id = 153
ORDER BY payment_date ASC;

-- Salary Update History by employees

SELECT
employee_id,
round(payout_amount,0) AS "Salary",
Min(payment_date)
FROM payouts
GROUP BY 
employee_id,
payout_amount
ORDER BY Employee_ID ASC, MIN(payment_date) ASC; -- Update by Years

-- Cumulative

SELECT 
p.employee_id,
p.payment_date,
p.payout_amount,
sum(a.payout_amount) as "Cumulative total",
sum(p.payout_amount) as "Cumulative total2"
FROM payouts p
JOIN payouts a
ON (p.payment_date>=a.payment_date
   AND p.employee_id = a.employee_id)
WHERE p.employee_id = 153 
GROUP BY 
p.employee_id,
p.payment_date,
p.payout_amount
ORDER BY payment_date;

-- With Partition and Order By it is much more easier than Ever

SELECT
employee_id,
payment_date,
payout_amount,
sum(payout_amount) over (partition by employee_id order by payment_date ASC) Cumulative
FROM payouts
WHERE employee_id = 153
ORDER BY payment_date;



SELECT * from payouts p1
JOIN payouts p2
ON p1.payment_date>=p2.payment_date AND p1.employee_id = p2.employee_id
WHERE p1.employee_id=100
ORDER BY p1.payment_date ASC,p2.payment_date ASC;

SELECT
p1.payment_date,
p1.payout_amount,
sum(p2.payout_amount)
FROM payouts p1
JOIN payouts p2 ON
p1.payment_date>=p2.payment_date
WHERE p1.employee_id = p2.employee_id
AND p1.payment_date<='1APR2020'
AND p1.employee_id = 101
GROUP BY 
p1.payment_date,
p1.payout_amount
ORDER BY p1.payment_date ASC;






