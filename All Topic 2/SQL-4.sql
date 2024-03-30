
-- Conditional expressions [Case,Decode]
-- Can be used SELECT and WHERE clauses
-- Simple case expression, searched case expression
-- ()-is not neccesary

SELECT 
sales_date,
order_date,
sales_units,
(CASE 
  WHEN sales_units>200 THEN 'High'
    WHEN sales_units>150 THEN 'Medium'
      ELSE 'Low'
        END) CS1,
game_id , -- Simple case expression, no comparison (>,< ...)
 (CASE game_id
  WHEN 'G_ID1' THEN 'Okey'
    WHEN 'G_ID1' THEN 'lz'
      ELSE 'Not'
        END) CS2,
 (CASE  -- this is better, beacuse you can compare different columns
  WHEN game_id = 'G_ID1' THEN 'Okey'
    WHEN order_date>'25May2022' THEN 'Good boy'
      ELSE 'ah'
        END) CS3
FROM sales;
 

SELECT 
case when sales_units>100 THEN 'good' else 'bed' end 
FROM sales; 
 
 
 -- THEN x,y,z should be same data type
SELECT 
first_name,
last_name,
(case
  WHEN employee_ID<150 THEN salary*1.5
  ELSE salary/1000
    END) AS "Updated Salary",
(Case
  when first_name='Steven' AND salary>20000 then 'High class'
    ELSE 'Low Class'
      END)
 FROM employees;


SELECT * FROM employees
WHERE
 (case when salary>22000 then 1
   when salary >20000 then 0.5
     else 0 end)=1; 


SELECT
employee_id,
first_name,
email,
salary,
decode(Email, 'SKING',1.2, 'LDEHAAN',1.3,0), 
decode(2,1,'one',2,'two',0), -- last is default value if not searched
(case when salary>20000 then 'yes' end) -- else is not defined, so null is returned
FROM employees;


SELECT
sales_date,
order_date,
game_id,
sales_units,
 (CASE WHEN GAME_ID IN ('G_ID1','G_ID2','G_ID12') THEN 'Good Games'
  ELSE 'Bad Games' END)
   --  DECODE(Game_ID,IN ('G_ID1','G_ID2','G_ID12'),'Good Games','Bad Games')
FROM sales;

-- Group functions
-- Group By and  null functions
-- AVG, COUNT, MAX, MIN, SUM, LISTAGG


SELECT last_day(sales_date),sum(sales_units) FROM sales
GROUP BY last_day(sales_date)
ORDER BY last_day(sales_date) ASC;


-- Distinct|ALL

SELECT 
 AVG(Sales_Units), 
 AVG(ALL Sales_units),
 AVG(Distinct Sales_Units) -- averages unique values of sales_units
 FROM sales
 WHERE Game_ID = 'G_ID1';

SELECT
AVG(commission_pct), 
AVG(nvl(commission_pct,0)) FROM employees;

-- COUNT

SELECT 
COUNT(*),
count(Sales_date),
count(Order_date), -- counting wihout NULL
count(ALL order_date),
count(DISTINCT order_date)
FROM sales;

SELECT
game_id, 
count(*),
count(1)
FROM sales
GROUP BY game_id;

SELECT
sales_date,
order_date,
decode(sales_date,order_date,1,0)
FROM sales;
 

SELECT COUNT(DISTINCT Order_Date) FROM 
(SELECT * FROM sales
WHERE order_Date IS NULL);


SELECT count(*), count(DISTINCT order_date) FROM 
(SELECT distinct(order_date) FROM sales);


SELECT
 count(*),
 count(commission_pct),
 count(distinct commission_pct),
 count(distinct nvl(commission_pct,0)) 
 FROM employees;


SELECt min(nl) FROM 
(SELECT NULL nl FROM dual);

-- MAX
-- Works for: Char, Date, Number

SELECT 
MAX(Sales_Units), 
MAX(Sales_date),
MAX(Game_ID),
MIN(sales_units),
MIN(NVL(sales_units,0)),
MIN(Sales_date),
MIN(Order_Date), -- NULL is Ignored
MIN(Game_Id)   
FROM sales;


SELECT 
Game_id,
sum(Sales_Units),
sum(All sales_units),
sum(Distinct Sales_units)
FROM sales
GROUP BY Game_id;

-- ListAgg
-- String Aggregation
-- ConcatenateX

SELECT Sales_units, 
ListAgg(game_id,',') WITHIN GROUP (ORDER BY Game_id DESC,Sales_date ASC)
FROM sales
GROUP BY sales_units;


-- SELECT Listagg(DISTINCT Salary,',') WITHIN GROUP (OREDR BY Salary) 
-- FROM sales;


SELECT 
Continent,
ListAgg(TRIM(Country),',') WITHIN GROUP (ORDER BY Population DESC) FROM Territory
GROUP BY Continent;



SELECT Listagg(first_name || ' ' || last_name|| ' - '||Salary,' ; ') WITHIN GROUP (ORDER BY Salary)
FROM employees
WHERE Salary>10000;


SELECT Listagg(first_name) WITHIN GROUP (ORDER BY Salary)
FROM employees
WHERE Salary>10000;


-- NULL values are ignored by default
-- Distinct is used to eliminate duplication
-- multiple group functions can be used in single query
-- Count(*) counts NULL, Count(ALL) doesn't


