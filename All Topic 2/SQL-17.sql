
  -- DataBase Objects Are: 
-- Tables, Views, Indexes, Constraints, Stored Procedures, Triggers, Functions, Synonyms, 
-- Sequence, Packages, Jobs(Unoficial)


-- aggregation over aggregation

SELECT 
extract(year FROM sales_date) year,
avg(sales_units)
FROM sales
group by extract(year FROM sales_date)
ORDER BY year;

SELECT 
max(avg(sales_units))
FROM sales
GROUP BY extract(year FROM sales_date)
ORDER BY extract(year FROM sales_date) ASC;

SELECT * FROM sales
WHERE game_id LIKE '%%/%' ESCAPE '/';
-- RollUp

SELECT
game_id,
customer_id,
sum(sales_units)
FROM sales
GROUP BY ROLLUP(game_id, customer_id);



SELECT
game_id,
customer_id,
sum(sales_units)
FROM sales
GROUP BY CUBE(game_id, customer_id);

-- Limiting Rows
SELECT * FROM
(SELECT s.*, row_number() OVER (ORDER BY sales_units DESC) RNK
FROM sales s
ORDER BY sales_units DESC)
WHERE rownum<=20;


 -- CTEs - Common table expression, Sub-Query Factoring

-- Data is not stored, it is like variable

 
 -- Old Syntax
WITH average_salary (avg_sal) AS
     (SELECT round(avg(salary),2) FROM employees)
SELECT * FROM employees e, average_salary av
WHERE e.salary>=av.avg_sal;

-- New Syntax
WITH average_salary (avg_sal) AS
     (SELECT round(avg(salary),2) FROM employees)
SELECT * FROM 
employees e
JOIN average_salary av
ON e.salary>=av.avg_sal;


SELECT cast(avg(salary) as int) FROM employees;
 
 
 -- departments which sum of salary is greater then average of Departments Salary
 
 SELECT avg(salary) FROM employees; -- 6461
 SELECT avg(sum(salary)) FROM employees
 group by department_id; -- 57K
 
 SELECT department_id, sum(salary) sal FROM employees
 group by department_id
 ORDER BY sal ASC;

-- Solution without CTE

 -- Not perfect solution
 SELECT department_id, sum(salary) FROM employees
 GROUP by department_id
 HAVING sum(salary)>
 (SELECT avg(sal) FROM 
 (SELECT sum(salary) sal FROM employees
 group by department_id));


 -- Aggregation over aggregation
 SELECT department_id, sum(salary) FROM employees
 GROUP by department_id
 HAVING sum(salary)>
 (SELECT avg(sum(salary)) FROM employees
 group by department_id);
 
 -- With CTE (clean solutions for such problems) 
 WITH expre (department_id,salary) AS
 (SELECT department_id, sum(salary) FROM employees
 GROUP by department_id)
 SELECT * FROM expre
 WHERE salary>(SELECT avg(salary) FROM expre);
 

-- Multiple CTEs

  -- Syntax
WITH emp1 (Dep_id, Salary,Definition) AS
          (SELECT department_id, max(salary),'MAX' FROM employees
          GROUP by department_id),
     emp2 (Dep_id,Salary,Definition) AS
          (SELECT department_id, min(salary), 'MIN' FROM employees
          GROUP by department_id),
     emp3 AS (SELECT max(salary) OVER() FROM emp1), 
     emp4 AS (SELECT min(salary) OVER FROM emp1)  
          /*SELECT * FROM emp1
          UNION ALL
          SELECT * FROM emp2*/
          SELECT * FROM emp3;

-- Average salary by departemnt, add columns

WITH avg_salary AS (
        SELECT  AVG(salary) AS average_salary,
                department_id
        FROM employees
        GROUP BY department_id)        
SELECT  e.first_name,
        e.last_name,
        e.department_id,
        e.salary,
        floor(avgs.average_salary) AS Avg_salary
FROM employees e
JOIN avg_salary avgs
ON e.department_id = avgs.department_id
ORDER BY department_id;

 -- CTE
SELECT
e.first_name,
e.last_name,
e.department_id,
e.salary,
(SELECT floor(avg(salary)) FROM employees
WHERE department_id = e.department_id) AS Dep_Avg_salary, -- Correlated
floor(avg(salary) Over(partition by department_id)) Dep_Avg_salary2,
floor(max(salary) Over(partition by department_id)) Dep_Max_salary
FROM employees e
ORDER BY e.department_id;


WITH emp1 AS (SELECT * FROM employees),
     SELECT * FROM employees,
     emp2 AS (SELECT * FROM employees);

-- Consequtive Days

SELECT
sales_date,
lag(sales_date) OVER (ORDER BY sales_date) prev,
sales_date - lag(sales_date) OVER (ORDER BY sales_date) Diffrence
FROM sales
ORDER BY sales_date;

 -- Recursive SQL queries
 -- Not in Oracle in a way that mySQL
 
 WITH nano (num) AS (
  SELECT 1 AS num FROM dual
  UNION ALL
  SELECT num + 1 FROM nano WHERE num < 10
)
SELECT num FROM nano;
 
 SELECT 
 extract(day FROM hire_date),
 extract(month FROM hire_date)
  FROM employees;
 
 SELECT to_char(sysdate,'HH24'),
        to_char(sysdate,'MI'),
        (cast(sysdate AS date) - trunc(sysdate))*24*60 Minutes, 
        to_char(sysdate,'Q')*1 Quarter
  FROM dual;

    
  -- Retrieve data FROM Tables
  -- Boolean and Relational Operators
  -- WildCard and Special Operators
  
  SELECT * FROM games
  WHERE lower(game_name) BETWEEN 'b' AND 'i'
  ORDER BY game_name ASC;
  
  -- if we want to find % in col
SELECT * FROM 
(SELECT '%gio' Name FROM sales)
WHERE name LIKE '%/%%' ESCAPE '/';
  
SELECT * FROM 
(SELECT '%gio' Name FROM sales)
WHERE name LIKE '%/%%';

 
 -- Aggregate Functions
 -- Formatting
 -- Query on multiple Tables
 -- SubQueries
 
 -- Joins on HR DataBase
 
 
 -- Employee who earn less than Id 182
 
 SELECT * FROM employees
 WHERE salary < (SELECT salary FROM employees WHERE employee_id=182);
 
 SELECT e.* FROM employees e
 JOIN employees s
 ON e.salary < s.salary and s.employee_id = 182;
 
 -- Views
 
 -- CREATE VIEW AS (SELECT statement)
 -- CREATE VIEW (col1,col2,...) AS (SELECT statement)
 
 CREATE VIEW Copying AS (SELECT * FROM sales); 
 
 
 SELECT * FROM copying;
 DROP VIEW copying;
 SELECT * FROM copying;
 
 SELECT * FROM employees e
 WHERE exists (SELECT department_id FROM employees
                      WHERE department_id = e.department_id
                      GROUP BY department_id
                      HAVING min(salary)>10000);

 -- Same solution
 SELECT * FROM employees e
 WHERE 10000 < (SELECT min(salary) FROM employees
               WHERE department_id = e.department_id);

   
SELECT * FROM employees;
 
-- Pivoting

SELECT *
FROM (
    SELECT DEPARTMENT_ID, SALARY
    FROM Employees
) 
PIVOT
(
    AVG(SALARY) 
    FOR DEPARTMENT_ID IN (60 AS DEPARTMENT1, 90 AS DEPARTMENT2, 100 AS DEPARTMENT3) -- Department IDs to pivot
);



 

