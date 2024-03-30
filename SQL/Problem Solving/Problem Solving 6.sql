
  -- Problems Link : https://pdfcoffee.com/hr-schema-queries-and-plsql-programs-pdf-free.html
     -- : View, Trigger, Function, Declare Variable

 SELECT table_name FROM all_tables; 
 
 
 -- Joined in May
 SELECT * FROM EMPLOYEES WHERE TO_CHAR(HIRE_DATE, 'MON')= 'MAY';
 SELECT floor(1.23) FROM dual;
 SELECT ceil(1.23) FROM dual;
   
  -- Display the length of first name for employees WHERE last name contain character ‘b’ after 3rd position
   
   SELECT FIRST_NAME, LAST_NAME FROM EMPLOYEES WHERE INSTR(LAST_NAME,'B') > 3 
   SELECT first_name, last_name FROM employees  WHERE lower(last_name) LIKE '___b%'; 
   
   SELECT first_name, last_name FROM employees
   WHERE lower(last_name) LIKE '%b%';
   
   -- Display how many employees joined in each month of the current year
   
 SELECT 
 TO_CHAR(HIRE_DATE,'MM'), 
 COUNT (*) 
 FROM EMPLOYEES 
 WHERE TO_CHAR(HIRE_DATE,'YYYY')= TO_CHAR(SYSDATE,'YYYY') 
 GROUP BY TO_CHAR(HIRE_DATE,'MM');

 SELECT TO_CHAR(HIRE_DATE,'MM')*1 FROM employees;
  
 -- Display the month in which more than 5 employees joined in any department located in Sydney.
 
 SELECT TO_CHAR(HIRE_DATE,'MM-YYYY')
 FROM EMPLOYEES 
 JOIN DEPARTMENTS 
 USING (DEPARTMENT_ID) 
 JOIN  LOCATIONS USING (LOCATION_ID) 
 WHERE  CITY = 'Seattle'
 GROUP BY TO_CHAR(HIRE_DATE,'MM-YYYY')
 HAVING COUNT(*) > 5;
  
 SELECT to_Char(hire_date,'MM-YYYY') FROM employees;
  
  -- Display details of departments in which the maximum salary is more than 10000.
   
 -- First Solution

SELECT * FROM departments
WHERE department_id IN
(SELECT department_id FROM employees
GROUP BY department_id
HAVING max(salary)>10000);
  
  -- Third Highest Salary
  
SELECT salary FROM employees e
  WHERE 2 =(SELECT count(distinct  salary) FROM employees
           WHERE salary>e.salary);       

SELECT salary FROM employees ORDER BY salary DESC;

 -- Display the year in which maximum number of employees joined 
   -- along with how many joined in each month in that year
  
 -- One Solution, with CTE I Suppose it is lot easier, or with PL/SQL
  SELECT 
  to_char(hire_date,'YYYY') Year,
  to_char(hire_date,'MON') Month,
  count(employee_id)
  FROM employees
  WHERE to_char(hire_date,'YYYY') IN  
  (SELECT year FROM  
      (SELECT 
      to_char(hire_date,'YYYY') Year,
      count(employee_id) cnt 
      FROM employees
      GROUP BY to_char(hire_date,'YYYY'))
  WHERE cnt = 
  (SELECT MAX(cnt) FROM
      (SELECT 
      to_char(hire_date,'YYYY') Year,
      count(employee_id) cnt 
      FROM employees
      GROUP BY to_char(hire_date,'YYYY'))))
GROUP BY 
  to_char(hire_date,'YYYY'),
  to_char(hire_date,'MON');

-- Simplier version with CTE
WITH Summr (Year,Month,Cnt) AS
(SELECT 
 to_char(hire_date,'YYYY'),
 to_char(hire_date,'MON'),
 count(employee_id)
 FROM employees
 GROUP BY 
 to_char(hire_date,'YYYY'),
 to_char(hire_date,'MON'))
 SELECT * FROM Summr 
 WHERE Year  = 
 (SELECT year FROM summr
  group by year
  Having sum(cnt) = (SELECT max(sum(cnt)) FROM Summr
                    GROUP BY Year));


-- Link: https://www.slideshare.net/Pyadav010186/sql-queries-interview-questions
  -- SQL Interview Questions
    

  -- Annual Sales changes of each game
  SELECT * FROM sales;
  SELECT * FROM games;
  SELECT * FROM money;
  Select table_name FROM all_tables;
  
 -- General Table 
SELECT
s.sales_date,
extract(year FROM s.sales_date) YEAR,
g.game_name,
s.sales_units,
m.price,
m.cost
FROM sales s
JOIN games g
ON s.game_id = g.game_id
JOIN money m
ON s.game_id = m.game_id
ORDER by g.game_name, s.sales_date ASC; 
  
-- Detailed Info

SELECT
extract(year FROM s.sales_date) YEAR,
g.game_name,
sum(s.sales_units) Units_sold,
min(m.price) Price,
min(m.cost) cost,
floor(sum(s.sales_units*m.price)) Revenue,
floor(sum(s.sales_units*m.cost)) Cost,
floor(sum(s.sales_units*(m.price-m.cost))) Profit
FROM sales s
JOIN games g
ON s.game_id = g.game_id
JOIN money m
ON s.game_id = m.game_id
GROUP BY 
extract(year FROM s.sales_date),
g.game_name
ORDER by g.game_name, year ASC; 


 -- YoY Change of Games Sales
   -- Nice Solution
SELECT
extract(year FROM s.sales_date) YEAR,
g.game_name,
floor(sum(s.sales_units*m.price)) Revenue,
lag(floor(sum(s.sales_units*m.price))) OVER (partition by g.game_name ORDER BY extract(year FROM s.sales_date)) Prev_Year_Sales,
floor(sum(s.sales_units*m.price)) - 
lag(floor(sum(s.sales_units*m.price))) OVER (partition by g.game_name ORDER BY extract(year FROM s.sales_date)) Sales_Delta
FROM sales s
JOIN games g
ON s.game_id = g.game_id
JOIN money m
ON s.game_id = m.game_id
GROUP BY 
extract(year FROM s.sales_date),
g.game_name
ORDER by g.game_name, year ASC; 
 
 -- if changes not decrease more than 3000

 -- Creating Table, CTE is better solution Generally
CREATE TABLE Sales_Delta AS
(SELECT
extract(year FROM s.sales_date) YEAR,
g.game_name,
floor(sum(s.sales_units*m.price)) Revenue,
lag(floor(sum(s.sales_units*m.price))) OVER (partition by g.game_name ORDER BY extract(year FROM s.sales_date)) Prev_Year_Sales,
floor(sum(s.sales_units*m.price)) - 
lag(floor(sum(s.sales_units*m.price))) OVER (partition by g.game_name ORDER BY extract(year FROM s.sales_date)) Sales_Delta
FROM sales s
JOIN games g
ON s.game_id = g.game_id
JOIN money m
ON s.game_id = m.game_id
GROUP BY 
extract(year FROM s.sales_date),
g.game_name);

  
SELECT game_name FROM sales_delta
GROUP by Game_name
HAVING min(sales_delta)>-3000;

SELECT * FROM games;
  
-- Games which don't have sales at All
 -- NOT IN
SELECT * FROM games
WHERE game_id NOT IN
(SELECT game_id FROM sales); 
  -- Join
SELECT g.* FROM games g
LEFT JOIN sales s
ON g.game_id = s.game_id
WHERE s.sales_units IS NULL;
 -- NOT EXISTS
SELECT * FROM games g
WHERE NOT EXISTS
(SELECT * FROM sales
WHERE g.game_id = g.game_id);


SELECT distinct(game_name) FROM sales_delta
WHERE year=2012 AND sales_delta<0;

SELECT * FROM sales_delta;
 
 SELECT * FROM
 (SELECT
 g.game_name,
 to_char(s.sales_date, 'MON') Month,
 to_char(s.sales_date, 'MM')*1 Mn,
 sum(s.sales_units) sales,
 rank() over (partition by to_char(s.sales_date, 'MON') ORDER BY sum(s.sales_units) DESC) Ranking 
 FROM sales s
 JOIN games g
 ON s.game_id = g.game_id
 GROUP BY 
 g.game_name,
 to_char(s.sales_date,'MON'),
 to_char(s.sales_date,'MM')*1)
 WHERE Ranking<=5
 ORDER BY MN ASC, sales DESC;
 
 
-- Total Sales for each product

 SELECT
 g.game_name,
 floor(nvl(sum(s.sales_units*m.price),0)) Sales
 FROM sales s
 JOIN games g
 ON s.game_id = g.game_id
 JOIN money m
 ON s.game_id = m.game_id
 group by g.game_name
 ORDER BY sales DESC;


 -- SELECT Product and Years,in which product sales is greater than average of all years sales of that product
   

SELECT
to_char(s.sales_date,'YYYY') Year,
g.game_name,
floor(sum(s.sales_units*m.price)) AS sales
FROM sales s
JOIN games g
ON s.game_id = g.game_id
JOIN money m
ON s.game_id = m.game_id
GROUP by 
to_char(s.sales_date,'YYYY'),
g.game_name
having floor(sum(s.sales_units*m.price))>
(SELECT avg(ka.sales) FROM  
    (SELECT
    to_char(sa.sales_date,'YYYY') Year,
    ga.game_name game_name,
    floor(sum(sa.sales_units*ma.price)) AS sales
    FROM sales sa
    JOIN games ga
    ON sa.game_id = ga.game_id
    JOIN money ma
    ON sa.game_id = ma.game_id
    GROUP by 
    to_char(sa.sales_date,'YYYY'),
    ga.game_name) ka
WHERE g.game_name = KA.game_name)
ORDER BY g.game_name, Year ASC;
 
-- With CTE
  
WITH Smr (Year,Game,Sales) AS
(SELECT 
  to_char(s.sales_date,'YYYY'),
  g.game_name,
  sum(s.sales_units*p.price)
  FROM sales s
  JOIN games g
  ON s.game_id = g.game_id
  JOIN money p
  ON g.game_id = p.game_id
  group by 
  to_char(s.sales_date,'YYYY'),
  g.game_name) 
 SELECT * FROM  Smr a
 WHERE sales > (SELECT avg(sales) FROM Smr
                 WHERE game = a.game)
 Order by Game,Year ASC;

 
  
 
 -- Compare of two games sales: OverWatch, Mario
    
    
 -- With JOINs
 
 SELECT fr.year,fr."Mario Sales",sc."OverWatch Sales" FROM
        (SELECT
        extract(year FROM s.sales_date) year,
        g.game_name,
        sum(s.sales_units) "Mario Sales"
        FROM sales s
        JOIN games g
        ON s.game_id = g.game_id and g.game_name = 'Mario'
        GROUP by
        extract(year FROM s.sales_date),
        g.game_name) fr
 FULL JOIN  
        (SELECT
        extract(year FROM s.sales_date) year,
        g.game_name,
        sum(s.sales_units) "OverWatch Sales"
        FROM sales s
        JOIN games g
        ON s.game_id = g.game_id and g.game_name = 'OverWatch'
        GROUP by
        extract(year FROM s.sales_date),
        g.game_name)  SC
ON fr.year = sc.year
ORDER BY fr.year ASC;
  
-- With CTE
WITH Smr (Year,Game,Sales) AS 
(SELECT
  extract(Year FROM s.sales_date),
  g.game_name,
  sum(s.sales_units)
  FROM sales s
  JOIN games g
  ON s.game_id = g.game_id
  GROUP by
  g.game_name,
  extract(Year FROM s.sales_date))
  SELECT 
  Year,
  SUM(CASE WHEN Game='Mario' THEN sales else 0 end) Mario,
  SUM(CASE WHEN Game='OverWatch' THEN sales else 0 end) OverWatch
  FROM Smr
  GROUP BY Year
  ORDER by Year;

 -- With Case, Without CTE
  
 
 SELECT
 to_char(s.Sales_date,'YYYY') Year,
 sum(CASE WHEN g.game_name = 'Mario' THEN s.sales_units ELSE 0 END) Mario,
 sum(CASE WHEN g.game_name = 'OverWatch' THEN s.sales_units ELSE 0 END) OverWatch
 FROM sales s
 JOIN games g
 ON s.game_id = g.game_id
 GROUP by to_char(s.Sales_date,'YYYY')
 Order by Year ASC;
 
 
 -- Incorrect Versions of above task
 -- SELF Join
   --
  SELECT 
  extract(year FROM fr.sales_date) Year,
  sum(fr.sales_units) "Mario",
  sum(sc.sales_units) "OverWatch"
  FROM sales fr
  JOIN sales sc
  ON 
   extract(year FROM fr.sales_date) = extract(year FROM sc.sales_date)
  WHERE 1=1 
  AND 
  fr.game_id  = (SELECT game_id FROM games WHERE game_name = 'Mario')
  AND
  sc.game_id  = (SELECT game_id FROM games WHERE game_name = 'OverWatch')
  GROUP BY extract(year FROM fr.sales_date)
  ORDER BY Year ASC;


  SELECT 
  extract(year FROM fr.sales_date) Year,
  sum(fr.sales_units) "Mario",
  sum(sc.sales_units) "OverWatch"
  FROM sales fr
  JOIN sales sc
  ON extract(year FROM fr.sales_date) = extract(year FROM sc.sales_date)
  JOIN games gf
  ON fr.game_id = gf.game_id
  JOIN games gs
  ON sc.game_id = gs.game_id
  WHERE gf.game_name  = 'Mario' AND gs.game_name = 'OverWatch'
  GROUP BY extract(year FROM fr.sales_date)
  ORDER BY Year ASC;

-- Case Checking
 
SELECT
sales_date,
CASE WHEN lower(game_id) = 'g_id1' THEN sum(sales_units) ELSE 0 END
  FROM sales
  GROUP BY 
  sales_date;
  
  
SELECT
sales_date,
sum(CASE WHEN lower(game_id) = 'g_id1' THEN sales_units ELSE NULL END) Sales
  FROM sales
  GROUP BY 
  sales_date;
 -- Sum(Null)


 -- Ratios of Sales of each product by years
 
 SELECT
 extract(year FROM s.sales_date) Year,
 g.game_name,
 sum(s.sales_units*m.price) Revenue,
                            
 round(sum(s.sales_units*m.price) / sum(sum(s.sales_units*m.price)) over(partition by g.game_name),2) Portion
 FROM sales s
 JOIN games g
 ON s.game_id = g.game_id
 JOIN money m
 ON g.game_id = m.game_id
 GROUP by 
 extract(year FROM s.sales_date),
 g.game_name
 ORDER by g.game_name, Year ASC;


-- Unpivoting Table
 -- Rows Should be Game names and Columns Should be Year, Interct should be revenue
CREATE TABLE Summarize_sales AS
(SELECT year, game_name, revenue FROM sales_delta
 WHERE year<2013);

SELECT * FROM summarize_sales;
 -- AS-ის დაწერა აქ არ უნდა იდეაში
 -- LINK for Pivot/Unpivot: https://www.youtube.com/watch?v=4p-G7fGhqRk
   

SELECT * FROM
(SELECT 
game_name,
year,
revenue
FROM summarize_sales) Sl_dt
PIVOT 
(SUM(revenue) for year IN (2010,2011,2012)) PV;
 
-- Without pivoting
  
SELECT * FROM
(SELECT 
 game_name,
 year,
 revenue
 FROM summarize_sales)Sl_dt
 PIVOT 
 (SUM(revenue) 
 for year IN (SELECT year FROM summarize_sales) 
   ) PV;
 
 -- Unpivot With Decode
 -
 SELECT 
 Game_name,
 max(DECODE(year,2010,revenue)) "2010",
 max(DECODE(year,2011,revenue)) "2011",
 max(DECODE(year,2012,revenue)) "2012"
 FROM summarize_sales 
 group by game_name;
 
 -- Unpivot With Case
 
SELECT 
  Game_name,
  max(CASE WHEN year=2010 THEN REVENUE else NULL END) "2010",
  max(CASE WHEN year=2011 THEN REVENUE else NULL END) "2011",
  max(CASE WHEN year=2012 THEN REVENUE else NULL END) "2012"
 FROM summarize_sales
 group by game_name;

-- 1 trick
SELECT count(*),count(1) FROM sales;    
    
    -- Genereate Sequenece
    -- N
     
    SELECT LEVEL FROM dual connect by LEVEL<=&N;
    
 -- Hierarchycal queries can be used to:
  -- Display all fridays between 2005 and 2010
  -- to repeat rows
  -- to display words in seperate rows
   
 
  
  SELECT substr('SMILE',level,1) FROM dual
  CONNECT BY LEVEL<=LENGTH('SMILE');
    
SELECT 
ASCII('A'),
chr(65),
DUMP('A') -- nothing special, info 
FROM dual;  

 -- ASCII cars
 -- DUMP second parameters changes lot of thing 
SELECT substr(DUMP('Smile'),15) FROM dual;

 -- Manager's Manager
 
 SELECT 
 e.first_name || ' ' || e.last_name Employee_name,
 m.first_name || ' ' || m.last_name Manager_name,
 mm.first_name || ' '|| mm.last_name Managers_Manager
 FROM employees e
 JOIN employees m 
 ON e.manager_id = m.employee_id
 JOIN employees mm
 ON m.manager_id = mm.employee_id;
 
 -
 -- randomg number
 SELECT DBMS_Random.value FROM dual; 
 
 -- Median
 SELECT
 game_id,
 last_day(sales_date),
 floor(stddev(sales_units)),
 median(sales_units) FROM sales
 GROUP by game_id,last_day(sales_date);
 
 -- Minimum sale for each product without group by can me made with Row_Number Partition/Order BY and WHERE over it
 
 SELECT 
 game_genre,
 wm_concat(game_name) AS List
 FROM games
 GROUP BY game_genre;
 
 -- PIVOT/UNPIVOT are advanced topics
 
 -- Min and Max values of contiguous rows
   -- Row_number-ის და Partition
   
   -- Query Performance
   -- Sales by years and Sales of Mario
   
   -- Wrong Solution (bad performance)
   
   SELECT
   s.year,s.sales,o.mario FROM
   (SELECT
    extract(year FROM sales_date) year,
    sum(sales_units) sales
    FROM sales
    GROUP by extract(year FROM sales_date)) s
   LEFT JOIN 
   (SELECT
    extract(year FROM sales_date) year,
    sum(sales_units) mario 
    FROM sales s
    JOIN games g
    ON s.game_id = g.game_id and g.game_name = 'Mario'
    GROUP by extract(year FROM sales_date)) o
   ON s.year = o.year
   ORDER BY s.year ASC
   
   -- Correct Solution (Great Performance)
   
   SELECT 
   extract(year FROM s.sales_date) Year,
   sum(s.sales_units),
   SUM(CASE WHEN s.game_id = (SELECT game_id FROM games WHERE game_name = 'Mario') 
        THEN s.sales_units ELSE NULL END) "Mario"
   FROM sales s
   GROUP BY extract(year FROM s.sales_date)
   ORDER BY Year ASC;
   
   
   -- Same Logic: LEFT JOIN, (NOT IN or NOT EXISTS)
   -- Same for Inner JOIN and IN or EXISTS, if we just checking existence
   
    
   
   
   
