
ALTER USER hr ACCOUNT UNLOCK;
ALTER USER hr IDENTIFIED BY hr;


-- HR tables
SELECT * FROM employees;
SELECT * FROM countries;
SELECT * FROM departments;
SELECT * FROM jobs;
SELECT * FROM job_history;
SELECT * FROM locations;
SELECT * FROM regions;
-- My tables
SELECT * FROM sales;
SELECT * FROM customers;
SELECT * FROM territory;
SELECT * FROM games; 
SELECT * FROM money;


-- Desc(ribe) sales
-- info(rmation) sales
                  
-- Control + E

SELECT * FROM dual;

SELECT 
Order_Date,
Sales_Units*2 AS "Saler 2", 
game_id "Game_Name", 
'My Name is Giorgi' as Sent, 
'my name is giorgi',
q'[I'm pretty strong dude]' as "output", 
q'(I'm pretty strong dudea)' as "output2", 
sales_Units || '23'
FROM sales;


-- || concatenation operator
SELECT name,'Gender is: ' || gender FROM customers;

SELECT order_date || ' okey' as checking FROM sales; -- null is ignored

-- Unique and distinct are same
SELECT distinct * FROM sales;

--- +,-,*,/ paranthesis
SELECT 
round(salary,0), 
salary*12+133 as "annual salary",
hire_date+23 as "New Date",
trunc(sysdate)+2, 
salary,
commission_pct,
salary+commission_pct
FROM employees;

-- arithemtic operations with null returns nulls

SELECT distinct customer_id,game_id,order_date FROM sales
WHERE Game_id = 'G_ID4'; 

-- only one distinct key word, before first column

-- Where Calause
   -- =,<,>, [<>,!=], <=,>=,Between, IN, Like, NULL, and, or, not

SELECT * FROM sales
WHERE 1=1 -- for corecting Where statements easily
AND sales_units BETWEEN 100 AND 200
AND sales_Date BETWEEN '1-Jan-2014' AND '1-Jan-2040'
AND Customer_ID IN ('ID1','ID2','23'); -- 45


SELECT * FROM sales
WHERE sales_units IN ('132',1); -- ასეთ დროს რიცხვად აღიქვამს


SELECT  * FROM user_tab_columns
WHERE table_name = 'SALES';

-- % any, _ only one character
SELECT * FROM sales
WHERE 1=1
and game_ID LIKE '%1%';

-- strings are case-sensitive
SELECT * FROM customers
WHERE gender LIKE 'F%';

-- Distinct values FROM table
SELECT distinct * FROM sales
WHERE order_date IS NULL;

-- AND, OR, NOT
SELECT * FROM sales
WHERE 1=1
AND order_date IS NOT NULL
AND (sales_units>180 OR customer_id LIKE '%9%');

SELECT * FROM sales
WHERE 1=1
AND (order_date >'1-Jan-2020'
OR order_date <'1-Jan-2023')
AND order_date IS NOT NULL;


SELECT * FROM employees 
WHERE 
commission_pct<0
OR salary>20000;

SELECT sales_units,order_date,Sales_date FROM Sales
WHERE order_date>'1-Jan-2045' OR sales_units>100;


SELECT 
sales_date,
Order_date,
Sales_Units*2.3+100 AS "Bonus",
Sales_Units*0.7 AS Bons
 FROM sales
ORDER BY 
"Bonus" asc, -- can be sorted by alias
bons desc,
sales_units desc,
sales_date desc;


-- column_name, alias, or Column Number
-- asc is default setting
SELECT * FROM sales
ORDER BY 1,order_date;

-- null values are last in ascending order
-- not neccesary to SELECT sorder columns
SELECT customer_id, Game_id FROM sales
ORDER BY order_date DESC;

-- NULLS first, NULLS Last

SELECT * FROM sales
ORDER BY order_date ASC;

SELECT * FROM sales
ORDER BY order_date ASC NULLS FIRST;

SELECT * FROM sales
ORDER BY order_date DESC NULLS FIRST;


-- Row Num, Row ID
-- Row ID -- unique identifier
-- Row ID never changes
-- Row Num changes every time

SELECT 
sales_date,
order_date,
rowid,
rownum FROM sales
WHERE 1=1
AND customer_id LIKE 'ID3%'
AND rownum<=10;

SELECT sales_date,order_date,sales_units,rownum FROM sales
WHERE rownum<11
ORDER BY sales_units DESC;

-- rowNum is calculated before sorting, that's why we can't use it as a limit like mySQL
SELECT sales_date,customer_id,sales_units,rownum FROM sales;

SELECT sales_date,customer_id,sales_units,rownum FROM sales
ORDER BY sales_units desc;

-- LIMIT-ing rows with rowNum
SELECT sales_date,order_date,sales_units,rowid,rownum FROM
 (SELECT sales_date,order_date,sales_units,rowid 
 FROM sales
 ORDER BY sales_units desc)
 WHERE rownum<=11;


SELECT * FROM 
(SELECT * FROM sales ORDER BY sales_date)
ORDER BY order_date;

SELECT sales_date,order_date,sales_units,rownum FROM sales;

SELECT sales_date,order_date,sales_units,rowid,rownum FROM
  (SELECT sales_date,order_date,sales_units,rowid 
  FROM sales
  ORDER BY sales_units desc)
 WHERE rownum<=11;


SELECT sales_date,order_date,sales_units FROM sales
ORDER BY sales_units DESC;
-- OFFSET 1 ROW[s] FETCH FIRST 10 rows only[with ties];


