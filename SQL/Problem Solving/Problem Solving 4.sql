
 -- LINK for questions: https://www.slideshare.net/MichaelBelete/sql-queries-questions-and-answers
 
SELECT * FROM sales
ORDER BY 1,2 ASC, 3 DESC;
 
-- MONTHS Joined

SELECT 
to_char(trunc(hire_date),'Month') AS "Month",
count(employee_id)
FROM employees
GROUP BY 
to_char(trunc(hire_date),'Month'),
extract(month FROM hire_date) -- for only sorting, good trick, every Month Name have 1 Unique Month Number
ORDER BY extract(month FROM hire_date);
 
-- by Year and month

SELECT
to_char(trunc(hire_date),'YYYY') AS "Year",
to_char(trunc(hire_date),'MM') AS "Month",
Count(employee_id)
FROM employees 
GROUP BY
to_char(trunc(hire_date),'YYYY'),
to_char(trunc(hire_date),'MM')
ORDER BY "Year","Month";

-- Max Salary for each department

SELECT * FROM employees
WHERE (department_id, salary) IN
(SELECT department_id, max(salary) FROM employees
GROUP BY department_id)
ORDER BY department_id;


-- Nth + 1 Largest salary
   

SELECT distinct e.salary FROM employees e
WHERE 3 = 
  (SELECT count(distinct salary) FROM employees
  WHERE salary>e.salary); -- Correlated Subquery
 

SELECT salary FROM employees
ORDER BY salary DESC; 

-- Checker
SElECT distinct salary FROM employees
ORDER BY salary DESC;


-- More than any employee in department 30

SELECT * FROM employees
WHERE salary > ALL
(SELECT salary FROM employees WHERE department_id = 30);

-- Departament with no employees

SELECT * FROM departments
WHERE department_id NOT IN 
(SELECT department_id FROM employees
WHERE department_id IS NOT NULL);

-- 2nd way
SELECT * FROM departments d
WHERE NOT EXISTS 
      (SELECT * FROM employees WHERE department_id = d.department_id);

-- Which employees department doesn't exist in department table

SELECT employee_id,first_name,department_id FROM employees e
WHERE NOT EXISTS
      (SELECT * FROM departments d WHERE d.department_id = e.department_id);

-- Employees who earn more than average of their department

SELECT * FROM employees e
WHERE salary > 
      (SELECT avg(salary) FROM employees
      WHERE department_id = e.department_id);


-- Employees with deparment_name and city

SELECT
e.first_name,
e.last_name,
d.department_name,
l.city
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
JOIN locations l
ON d.location_id = l.location_id;

-- Old Syntax

SElECT 
e.first_name,
e.last_name,
d.department_name,
l.city
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id AND d.location_id = l.location_id;

-- Departments and total employees
SELECT
d.department_name,
count(e.employee_id)
FROM departments d
JOIN employees e
ON d.department_id = e.department_id
GROUP BY department_name;

-- თითოელი Job_id
SELECT
j.job_id,
count(e.employee_id)
FROM jobs j
JOIN employees e
ON e.salary BETWEEN j.min_salary AND j.max_salary
GROUP BY j.job_id;

-- Sames as, interesting Point Giorgi
SELECT
j.job_id,
count(e.employee_id)
FROM jobs j
JOIN employees e
ON j.min_salary <= e.salary AND j.max_salary>= e.salary
GROUP BY j.job_id;



SELECT 
distinct(j.job_title)
FROM jobs j
JOIN employees e
ON j.job_id = e.job_id
JOIN departments d
ON e.department_id = d.department_id
WHERE d.department_name IN ('Sales','Accounting');

   
   -- MoM changes
   
 SELECT 
 last_day(f.sales_date) "Eom",
 sum(f.sales_units),
 sum(s.sales_units)
  FROM sales f
  JOIN sales s
  ON s.sales_date BETWEEN last_day(add_months(f.sales_date,-2))+1 AND  last_day(add_months(f.sales_date,-1))
  GROUP BY last_day(f.sales_date)
  ORDER BY "Eom";


SELECT 
  last_day(sales_date),
  last_day(add_months(sales_date,-2))+1 AS "Start",
  last_day(add_months(sales_date,-1)) AS "End",
  sum(sales_units)
  FROM sales
  GROUP BY 
  last_day(sales_date),
  last_day(add_months(sales_date,-2))+1,
  last_day(add_months(sales_date,-1))
  ORDER BY last_day(sales_date);



SELECT
  add_months(last_day(s.sales_date),1),
  sum(s.sales_units) AS sales
  FROM sales s
  WHERE  EXISTS 
  (SELECT * FROM sales
  WHERE sales_date BETWEEN 
  last_day(add_months(s.sales_date,-2))+1 AND 
  last_day(add_months(s.sales_date,-1)))
  GROUP BY last_day(s.sales_date)
  ORDER BY last_day(s.sales_date) ASC;


SELECT 
 last_day(s.sales_date) "Eom",
 sum(s.sales_units) "Current",
 sum(a.sales) "Previous",
 sum(s.sales_units) - sum(a.sales) Diffrence,
 Round((sum(s.sales_units) - sum(a.sales))/(sum(a.sales)),2) "% Growth"
 FROM 
(SELECT last_day(sales_date) sales_date, sum(sales_units) sales_units FROM sales
GROUP BY last_day(sales_date)) s
LEFT JOIN 
(SELECT
  add_months(last_day(sales_date),1) last_d,
  sum(sales_units) sales
  FROM sales
  GROUP BY last_day(sales_date) 
  ORDER BY last_day(sales_date)) a
ON s.sales_date = a.last_d
GROUP BY last_day(s.sales_date)
ORDER BY "Eom" ASC;


-- Checker 
   
SELECT
add_months(last_day(sales_date),1),
sum(sales_units) 
FROM sales
GROUP BY last_day(sales_date) 
ORDER BY last_day(sales_date);











