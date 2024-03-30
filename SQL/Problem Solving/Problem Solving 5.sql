

-- Problem Links : https://www.slideshare.net/tausy/sql-practice-questions-set-2

   -- N1
SELECT
min(salary),
max(salary),
round(avg(salary),0),
cast (avg(salary) as int),
max(salary) - min(salary),
sum(salary)
FROM employees;


  -- N4

SELECT
m.employee_id,
m.first_name || ' ' || m.last_name Manager_name,
e.first_name || ' ' || e.last_name Employee_name,
e.salary
FROM employees m
JOIN employees e
ON m.employee_id = e.manager_id
WHERE (m.employee_id, e.salary) IN 
(SELECT
  m.employee_id,
  min(e.salary)
  FROM employees m
  JOIN employees e
  ON m.employee_id = e.manager_id
  group by m.employee_id
  having max(e.salary)<6000)
order by m.employee_id ASC,e.salary ASC;


-- Manager_id and Min_salary of his employees for SubQuery
SELECT
  m.employee_id,
  min(e.salary)
  FROM employees m
  JOIN employees e
  ON m.employee_id = e.manager_id
  group by m.employee_id;

-- N5
SELECT 
  hire_date,
  EXTRACT(year FROM hire_date) as Year
  FROM employees;

-- N7 Number of employees with same Job
SELECT * FROM employees;
-- First Solution

SELECT sum(cnt) FROM 
(SELECT job_id, count(*) cnt FROM employees
GROUP BY job_id
having count(*)>1);

-- Second Solution
SELECT count(*) FROM employees e
WHERE EXISTS (SELECT * FROM employees
              WHERE employee_id<>e.employee_id AND job_id = e.job_id);


-- N8 Department Name, Location number, N of Employees, average salary of employees

SELECT 
d.department_name,
d.location_id,
count(e.employee_id),
round(avg(e.salary),1)
FROM departments d
JOIN employees e
ON d.department_id = e.department_id
GROUP BY
d.department_name,
d.location_id;


-- N52 I work and they work in same department

SELECT 
e.employee_id,
e.first_name || ' ' ||e.last_name FUll_Name,
listagg( a.first_name || ' '||a.last_name || ' ' ||a.employee_id ,', ') WITHIN GROUP (Order by a.employee_id)
FROM employees e
JOIN employees a
ON e.department_id = a.department_id AND e.employee_id <> a.employee_id
GROUP BY 
e.employee_id,
e.first_name || ' ' || e.last_name
order by e.employee_id;

 
 -- Another Link: https://www.slideshare.net/Pyadav010186/sql-queries-interview-questions
     -- W3School Excersises
 -- Cartesian Product
 
 SELECT * FROM games;
 SELECT * FROM customers;

SELECT g.game_name,c.name FROM games g
CROSS JOIN customers c
order by g.game_name;

-- WHERE Customer Name don't start with A and  Gender is not Male

SELECT g.game_name,c.name FROM games g
CROSS JOIN customers c
WHERE lower(c.name) NOT LIKE 'a%' AND c.gender<>'Male'
order by g.game_name;

-- Department Name Employee Id with Max Salary each department

-- First Method
SELECT
d.department_name,
e.employee_id,
e.salary
FROM departments d
JOIN employees e
ON d.department_id = e.department_id
WHERE (e.department_id,e.salary) IN
(SELECT department_id, max(salary) 
  FROM employees
  group by department_id)
  order by e.salary DESC; 
                           
-- Second Method
SELECT
d.department_name,
e.employee_id,
e.salary
FROM departments d
JOIN employees e
ON d.department_id = e.department_id 
AND e.salary = (SELECT max(salary) FROM employees
                WHERE department_id = d.department_id) -- Correlated Subquery 
order by e.salary DESC;
   

-- Grading Employees Salaries
CREATE TABLE Job_Grade
(Grade_Level varchar(20),
Lowest_Sal number,
Highest_Sal number);

SELECT * FROM job_grade;

INSERT ALL
 INTO Job_grade VALUES('C',1000,5000)
 INTO Job_grade VALUES('B',5001,15000)
 INTO Job_grade VALUES('A',15001,30000)
SELECT * FROM dual;

DELETE FROM job_grade;
COMMIT;

SELECT 
e.employee_id,
e.first_name || ' '|| e.last_name FULL_NAME,
e.salary,
g.grade_level
FROM employees e
JOIN job_grade g
ON e.salary BETWEEN g.lowest_sal AND g.highest_sal
order by e.salary DESC;


-- Employees who earn salary less than employee with id 182

-- With Join
SELECT e1.first_name,
       e1.last_name,
       e1.salary
  FROM employees e1
  INNER JOIN employees e2
    ON e1.salary < e2.salary
      AND e2.employee_id = 182;

-- With Where
SELECT
first_name,
last_name,
salary FROM employees
WHERE salary<(SELECT salary FROM employees 
              WHERE employee_id = 182);


-- job Title, full name, diffrence between max salary and employee salary
SELECT 
  j.job_title,
  e.first_name || ' '|| e.last_name AS full_name,
  (j.max_salary - e.salary) AS salary_diff
  FROM employees e
  INNER JOIN jobs j
  ON e.job_id = j.job_id;

-- Employees who earn more than minimum salary

SELECT * FROM jobs;

SELECT 
e.job_id,
e.salary,
j.min_salary
FROM employees e
JOIN jobs j 
ON e.job_id = j.job_id AND e.salary>j.min_salary;


-- Write a query in SQL to display the country name, city, and number of those departments WHERE at least 2 employees are working.

SELECT * FROM countries;
SELECT * FROM locations; -- Country_id
SELECT * FROM departments; -- location_id

SELECT
c.country_name,
l.city,
count(d.department_id)
FROM countries c
JOIN locations l
ON c.country_id = l.country_id
JOIN departments d
ON l.location_id = d.location_id
WHERE d.department_id IN (SELECT department_id FROM employees
                         GROUP BY department_id 
                         HAVING count(department_id)>=2)
GROUP BY c.country_name, l.city;


-- number of days worked for each row of job_history

SELECT 
       j.job_title,
       j.job_id,
       jh.employee_id,
       (jh.end_date - jh.start_date) AS num_days
FROM jobs j
JOIN job_history jh
ON j.job_id = jh.job_id
ORDER BY j.job_id ASC;

SELECT * FROM job_history;

-- Write a query in SQL to display full name(first and last name), job title
  -- starting and ending date of last jobs for those employees with worked without a commission percentage.



SELECT
e.first_name || ' ' || e.last_name FULL_NAME,
j.job_title,
jh.*
FROM employees e
JOIN (SELECT 
      employee_id,
      MAX(Start_date) Starting_date,
      MAX(end_date) Ending_date
      FROM job_history
      group by employee_id) jh
ON e.employee_id = jh.employee_id
JOIN jobs j
ON e.job_id = j.job_id
WHERE e.commission_pct IS NOT NULL;


 -- SubQueries N1

-- Employees who report to Payem
   
SELECT first_name,
       last_name,
       employee_id,
       salary
  FROM employees
  WHERE manager_id = (SELECT employee_id
                        FROM employees
                        WHERE first_name = 'Payam');

-- Those two queries are same

SELECT *
FROM employees
WHERE salary = 3000
AND manager_id = 121;

SELECT *
FROM employees 
WHERE (salary, manager_id) = (SELECT 3000, 121 FROM Dual);

 -- Whoe earns second Highest Salary
SELECT *
  FROM employees
  WHERE employee_id IN (SELECT employee_id
                          FROM employees
                          WHERE salary IN (SELECT MAX(salary)
                                             FROM employees
                                             WHERE salary < (SELECT MAX(salary)
                                                               FROM employees)));
-- More Clean Solution
SELECT * FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees
               WHERE Salary <> (SELECT Max(salary) FROM employees)); 
 

-- Location is Toronto

SELECT first_name,
       last_name,
       employee_id,
       job_id
  FROM employees
  WHERE department_id IN (SELECT department_id
                            FROM departments
                            WHERE location_id IN (SELECT location_id
                                                    FROM locations
                                                    WHERE city = 'Toronto'));


SELECT first_name,
       last_name,
       department_id
FROM employees
WHERE EXISTS (SELECT *
              FROM employees
              WHERE salary > 3700.00);
-- 2100 Min Salary
SELECT min(salary) FROM employees;

-- Select department who is also in department table and contains at least 1 employee

 -- HAVING 
SELECT department_id,
       SUM(salary)
  FROM employees
  WHERE department_id IN (SELECT department_id
                            FROM departments)
  GROUP BY department_id
  HAVING COUNT(employee_id) >= 1;



-- Employees whose salary is greater than their departments SUM*0.5

-- With SubQuery 
SELECT e1.first_name,
       e1.last_name
  FROM employees e1
  WHERE salary > (SELECT SUM(salary)*0.5
                    FROM employees e2 
                    WHERE e1.department_id =  e2.department_id);

-- = ANY is same as IN

-- GROUP BY can be used in this way, multiple SubQueries

SELECT *
  FROM departments
  WHERE department_id IN (SELECT department_id
                            FROM employees
                            WHERE employee_id IN (SELECT employee_id
                                                    FROM job_history
                                                    GROUP BY employee_id
                                                    HAVING COUNT(*) > 1)
                            GROUP BY department_id
                            HAVING MAX(salary) > 7000); 


   -- Manager who have more than 3 employees

SELECT first_name ||' ' || last_name AS full_name
  FROM employees
  WHERE employee_id IN (SELECT manager_id
                          FROM employees
                          GROUP BY manager_id
                          HAVING COUNT(*) >= 4);

-- Second Smallest Salary

SELECT *
  FROM employees
  WHERE salary IN (SELECT MIN(salary)
                     FROM employees
                     WHERE salary > (SELECT MIN(salary)
                                       FROM employees));

-- Highest salary in their department

SELECT department_id,
       first_name ||' '|| last_name  AS full_name,
       salary
  FROM employees e
  WHERE salary IN (SELECT MAX(salary)
                     FROM employees
                     WHERE department_id = e.department_id);

 -- Second Solution
SELECT department_id,
       first_name ||' '|| last_name  AS full_name,
       salary
    FROM employees e
    WHERE (department_id, salary) IN (SELECT department_id, max(salary) FROM employees
                                     GROUP BY department_id);

  -- Those who had more than one customer
  
  -- First Solution
SELECT salesman_id,
name
FROM salesman
WHERE salesman_id IN (SELECT salesman_id
                  FROM customer
                  GROUP BY salesman_id
                  HAVING COUNT(*) > 1);

 -- Second Solution 
SELECT salesman_id,
name 
FROM salesman a 
WHERE 1 < (SELECT COUNT(*)
           FROM customer 
           WHERE salesman_id = a.salesman_id);

-- find the sums of the amounts FROM the orders table, grouped by date, 
 -- eliminating all those dates WHERE the sum was not at least 1000 above the maximum order amount for that date

SELECT ord_date,
       SUM(purch_amt)
  FROM orders a
  GROUP BY ord_date
  HAVING SUM(purch_amt) > (SELECT MAX(purch_amt) + 1000
                             FROM orders b
                             WHERE a.ord_date = b.ord_date);

  
  
  -- to display the salesmen which name are alphabetically lower than the name of the customers.
   -- also interesting example
  SELECT *
  FROM salesman a
  WHERE EXISTS (SELECT *
                  FROM customer b
                  WHERE a.name < b.cust_name);
  
  
 --  display all orders with an amount smaller than the maximum amount for a customers in London
   -- First Solution
 SELECT *
  FROM orders
  WHERE purch_amt < (SELECT MAX(purch_amt)
                       FROM orders
                       WHERE customer_id IN (SELECT customer_id
                                             FROM customer
                                             WHERE city = 'London'));
  
  -- Second Solution
     -- Filtering With Join Condition (Old Syntax)

SELECT *
  FROM orders
  WHERE purch_amt < (SELECT MAX(purch_amt)
                     FROM orders a, customer b -- Join with old Syntax
                     WHERE a.customer_id = b.customer_id 
                     AND b.city = 'London');  
      
 -- display the name of each company, price for their most expensive product along with their Name.
 
 -- First Solution
 
 SELECT 
       c.com_name,
       i.pro_name,
       i.pro_price
  FROM item_mast i
  INNER JOIN company_mast c
  ON i.pro_com = c.com_id
  AND i.pro_price = (SELECT MAX(i.pro_price)
                     FROM item_mast i
                     WHERE i.pro_com = c.com_id);
 
 -- Second Solution
   
  SELECT c.com_name,
       i.pro_name,
       i.pro_price
   FROM item_mast i, company_mast c 
   WHERE i.pro_com = c.com_id
     AND i.pro_price = (SELECT MAX(i.pro_price)
                          FROM item_mast i
                          WHERE i.pro_com = c.com_id);

  
 -- SalesMan who has multiple customers
 
 -- First Solution (easy one)
 SELECT *
  FROM salesman
  WHERE salesman_id IN (SELECT salesman_id
                          FROM customer
                          GROUP BY salesman_id
                          HAVING COUNT(*) > 1); 
  
 -- Second Solution
  SELECT *
  FROM salesman 
  WHERE salesman_id IN (SELECT DISTINCT salesman_id 
                        FROM customer a 
                        WHERE EXISTS (SELECT *
                              FROM customer b 
                              WHERE b.salesman_id=a.salesman_id 
                                AND b.cust_name <> a.cust_name)); 


 -- extract the rows of all salesmen who have customers with more than one orders.
   
  -- First Solution
  SELECT *
  FROM salesman
  WHERE salesman_id IN (SELECT salesman_id
                          FROM customer
                          WHERE customer_id IN (SELECT customer_id
                                                  FROM orders
                                                  GROUP BY customer_id
                                                  HAVING COUNT(*) > 1));

  -- Second Solution 
  
  SELECT *
  FROM salesman a 
  WHERE EXISTS (SELECT *
                  FROM customer b     
                  WHERE a.salesman_id=b.salesman_id     
	                 AND 1 < (SELECT COUNT(*)              
		               FROM orders             
		               WHERE orders.customer_id=b.customer_id));

  
    








