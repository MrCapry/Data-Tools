-- Conversion function

-- implicit and explicit data conversion

SELECT 
sales_date,
order_date,
customer_id
FROM sales;

-- examples

SELECT * FROM sales
WHERE sales_units>'100';

SELECT * FROM sales
WHERE sales_date>'1May2023'; -- dates only written in strings

SELECT sales_units || customer_ID FROM sales;


-- To_Char, To_number, To_Date


-- To_Char converts in char (number of date)
 
SELECT 
to_char(23),
cast('23' as number),
to_char(a.sales_units),
to_char(sales_date,'day-mm-yyyy'), 
to_char(sales_date,'yy'),
to_char(sales_date,'RR'),
to_char(add_months(SYSDATE,-500),'RR'),
to_char(add_months(SYSDATE,-500),'YY'),
to_char(SYSDATE,'RR')
FROM sales a;


SELECT
to_char(SYSDATE,'DY'),
to_char(SYSDATE,'Dy'),
to_char(SYSDATE,'Day'),
to_char(SYSDATE,'HH'), -- by default HH12
to_char(SYSDATE,'HH12'),
to_char(SYSDATE,'HH24'),
to_char(SYSDATE,'MI'), -- minute
to_char(SYSDATE,'SS'), -- second
to_char(SYSDATE,'HH24'),
to_char(SYSDATE,'year'),
to_char(SYSDATE,'MM'),
to_char(SYSDATE,'MM-YYYY'),
to_char(SYSDATE,'month'),
to_char(SYSDATE,'Month'), -- case changer even one upper
to_char(SYSDATE,'Mon'),
to_char(SYSDATE,'MOn'),
to_char(SYSDATE,'DD'),
to_char(SYSDATE,'MONTH')
FROM sales;


SELECT 
to_char(SYSDATE, 'DDTH'),
to_char(SYSDATE,'YYYYTH'),
to_char(SYSDATE,'YYYYSP'),
to_char(SYSDATE, 'YYYYSPTH'),
to_char(SYSDATE, 'YYYYTHSP')
FROM sales;

-- numeric formatting: ?,0,$,L, , .

SELECT 
to_char(sales_units,'999,99'),
to_char(sales_units,'999.00$'),
to_char(sales_units,'999.00L'),
to_char(sales_units*200,'999,999.00L'),
to_char(sales_units*200,'999,00L'),
to_char(sales_units*200,'000,000.00L')
 FROM sales;

-- TO_NUMBER

SELECT
sales_date,
TO_NUMBER('$6,125.21','$99,999.99'),
 -- TO_NUMBER('$6,125.21','99,999.99') 
TO_DATE('Jun 12,2005','Mon DD, YYYY') 
FROM sales
WHERE sales_date > to_date('15-May-2024','DD-Mon-YYYY'); 


-- NULL related functions
-- NVL, NVL2
SELECT
sales_date,
order_date,
NVL(order_date,sysdate) 
FROM sales;


SELECT 
email,
salary,
commission_PCT,
NVL(commission_PCT,0)*salary as "Bonus",
NVL2(commission_PCT,1,0) as "Null Checker" 
-- second argument, if not NULL, third argument, if NULL, Doesn'e need to be 2nd and 3rd same data type as 1st
FROM employees;

SELECT
sales_date,
order_date,
NULLIF(sales_date,Order_Date) -- if equal, return null otherwise 1st expression
-- must be same data type (NULLIF)
FROM sales;

SELECT
first_name,
last_name,
length(first_name) as "Name Len",
length(last_name) as "Surname Len"
FROM employees
WHERE NULLIF(length(first_name),length(last_name)) IS NULL; 

-- Coalesce return first one that is not blank

SELECT 
commission_pct,
manager_id,
coalesce(commission_pct,manager_id,0),
coalesce(null, null, 1,2,3),
coalesce(null,null,null,'Among'), -- list must be same data type
coalesce(commission_pct,NULL)
FROM employees;



