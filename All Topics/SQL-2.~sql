 -- Single row functions
-- multiple row functions

-- character, numeric, date, conversion, general

-- uppwer, lower, initcap, 
-- substr, length, concat, instr, trim, replace, [lpad,rpad]


SELECt
customer_id,
name,
gender,
country,
lower(name),
upper(name),
initcap(name), 
initcap('my naMe is Giorgi 23')as checker
FROM customers
WHERE lower(country)>'r'; -- textComparison, აქ იდეაში ASCII-ის ითვალისწინებს

-- Lower function in LIKE operator (good usage)
SELECT * FROM customers
WHERE lower(gender) like 'm%';


-- character manipulation functions
SELECT 
customer_id,
name,
gender,
country,
substr(name,1,3) as subs,
length(gender)
FROM customers;

SELECT length(first_name) FROM employees;

SELECT
EMPLOYEE_ID,
FIRST_NAME, 
LAST_NAME, 
EMAIL,  
HIRE_DATE,  
SALARY,
substr(email,1,3),
substr(email,2), -- without N, returns everything
length(email),
concat(first_name,last_name) -- only two strings
FROM employees;


SELECT 
first_name,
substr(first_name,-4), 
substr(first_name,-4,2),
substr(first_name, 5,-2), 
length(first_name),
concat(first_name, last_name), -- only two strings
first_name || ' ' || last_name,
concat(concat(first_name,' '),last_name) -- double concating
FROM employees;

-- string, substring, starting position, occurance
 -- Instr(String, SubString, Position, Occurance)
SELECT 
first_name,
last_name,
instr(first_name,'a'), 
'I am Leagning Oracle bro' as sentence,
instr('I am Learning Oracle bro','a') as checker1,
instr('I am Learning Oracle bro','a',10) as checker2,
instr('I am Learning Oracle bro','a',10,3) as checker3,
instr('I am Learning Oracle bro','a',1,2) as checker4, 
instr('I am Learning Oracle bro','a',-1,1) as checker5
FROM employees;

 -- Starting Position
SELECT 
instr('aao','a',2)
--instr('aao','a',,2) 
FROM dual;



SELECT 
first_name || ' ' || last_name,
substr(
first_name || ' ' || last_name,
1,
instr(
first_name || ' ' || last_name,' ')-1) as name 
FROM employees;


 -- TRIM, LTRIM, RTRIM

-- leading, trailing, both
-- should start or end with that character
  -- both is by default
SELECT 
trim( '   my name is giorgi  ' ) as "trim",
trim('a' FROM  'aaaa aa giorgi aa') as "trim2" ,
trim(both 'a' FROM  'aaaa aa giorgi aa') as "trim3",
trim(leading 'a' FROM  'aaaa aa giorgi aa') as "trim4",
trim(trailing 'a' FROM  'aaaa aa giorgi aa') as "trim5",
-- trim ('ab' FROM 'ababacbab ab ') as "trim6" should only have one character, but RTRIM and LTRIM might have more than 1
trim('a' FROM 'Abaco') as "trim6", -- case sensitive
trim('b' FROM 'bbbacb') as "trim7", -- until different char
rtrim(' last maro kano  ') as "rtrim1", -- if not specified removes spaces
ltrim( 'abcbadk','abc') as "lftrim1", -- coule be multiple characters
rtrim(ltrim('www.youtube.com','w.'),'com.') as "nested", -- can be nested
ltrim('123131kaco','0123456789') as "nmb extract" 
FROM sales;
 

-- replace, LPAD, RPAD

SELECT 
replace('giorgi kargi Giwia','g','') as "rpl1", -- Case Sensitive არის
replace('giorgi','i') as "rpl2", -- if not specified, it is removed
to_number(replace(a.game_id,'G_ID')) as "rpl3",
1*replace(a.game_id,'G_ID') as "rpl4", -- can be converted that way
replace('giorgi goi', 'gi') as "rpl5", -- must have exact match
lpad('sql',5,'-') as "lpad1",
rpad('sql',6,'?') as "rpad1",
rpad('sql',2,'?') as "rpad2",
rpad('sql',30,'?') as "rpad3",
rpad('giorgi',1,'-') as "rpad4"
FROM sales a;


-- numeric functions
SELECT 
round(1.2314,2) as "rnd1",
round(151.2313,-2) as "rnd2",
trunc(1.2356,2) as "trnc",
trunc(1.2356) as "trnc2",
trunc(167.231,-2) as "trnc3", 
ceil(23.45) as "ceil",
floor(23.45) as "flr",
mod(35,6) as "md",
round(12.56) as "rnd3"
FROM sales;

-- nested functions


SELECT 
lpad(upper(concat('Giorgi',' Goderdzishvili')),30,'-') as "Nested1",
substr('Giorgi Goderdzishvili',instr('Giorgi Goderdzishvili',' ')+1) as "Nested2"
FROM sales;


-- Date values and Date operations
-- century, year, month, day, hour, minute, second
-- date, TimeStamp, TimeStap with time zone, TimeStap with time local time zone

-- automatic dates
SELECT  
a.sales_date,
a.order_date,
trunc(sysdate), -- oracle database installed
current_date, -- user local time
sysdate,
sessiontimezone, --timezone
systimestamp,
current_timestamp
FROM sales a
WHERE a.sales_date>'1-JUN-2023'
ORDER by a.sales_date ASC;



SELECT 
a.sales_date,
a.order_date,
trunc(sysdate),
trunc(sysdate)+3,
sysdate + 1/24, -- one hour
trunc((sysdate - a.order_date)/365) as "Years Gone"
FROM sales a
order BY "Years Gone" DESC NULLS LAST;

-- Date manipulation functions

SELECT 
a.sales_date,
a.order_date,
add_months(a.sales_date,-3) as "Add1",
add_months(a.sales_date,0) as "Add2", 
add_months(a.order_date,4) as "Add3", -- nothing happens in NULL
add_months('30-JAN-2023',1) as "Add4", 
add_months('29-JAN-2023',1) as "Add5",
months_between(sales_date,order_date) as "btw1", -- nothing happens in NULL
add_months(sysdate,12) as "Add6", 
add_months('1/JUN/2023',3) as "Date 1", 
add_months('1JUN2023',3) as "Date 2", 
add_months('1?JUN?2023',3) as "Date 3", 
round(sysdate,'Day'), 
round(sysdate,'Year'), 
round(sysdate,'Month'), 
round(sales_date,'Day'),
round(sales_date,'Year'),
round(sales_date,'Month')
 -- round(sysdate,'Quarter') 
FROM sales a;

-- Rounding - cloesest of start of current of next first week, month, year date

SELECT 
sales_date,
order_date,
round(sales_date,'day'),
-- truncs return 1st of down
trunc(sysdate,'year'),
trunc(sysdate,'month'),
trunc(sysdate,'day'),
extract( month FROM sysdate),
extract( day FROM sysdate),
extract( year FROM sysdate),
EXTRACT(HOUR FROM CAST(sysdate AS TIMESTAMP)) 
FROM sales;


SELECT sysdate+0.0123 - sysdate FROM dual;


SELECT
sales_date,
order_date,
next_day(sysdate,2), -- next monday
next_day(sysdate,'Monday')
FROM sales;



CREATE TABLE  Dt(dt) as
(SELECT sysdate FROM dual);

SELECT sysdate - dt FROM dt;




