
-- Problems Link: https://www.slideshare.net/imamhossain75054/dbms-5-mysql-practice-list-hr-schema

-- LIKE/NOT LIKE wildcards

SELECT employee_id,first_name,last_name FROM employees
WHERE 1=1
-- AND lower(first_name) LIKE 's%'
-- AND lower(first_name) NOT LIKE 's%'
-- AND lower(first_name) LIKE 's%' OR  lower(first_name) LIKE '%m'
-- AND (lower(first_name) LIKE '%o%' AND  lower(first_name) LIKE '%a%')
-- AND lower(first_name) LIKE '%o%a%' -- ზედიზედ თუა '%oa%';
-- AND first_name LIKE '___'
-- AND first_name LIKE '___%'; -- length more or equal to 3
AND lower(first_name) LIKE '%a_';


SELECT * FROM employees
WHERE length(first_name)<3;



SELECT 
e.first_name,
e.last_name,
e.salary,
j.min_salary,
j.max_salary,
j.max_salary - j.min_salary AS "Diffrence"
FROM employees e
JOIN jobs j
ON e.job_id = j.job_id
WHERE j.max_salary - j.min_salary>5000
ORDER BY "Diffrence" ASC;
 

SELECT 
e.employee_id,
e.first_name || ' '|| e.last_name,
h.start_date,
h.end_date,
CASE WHEN h.start_date<'12DEC1989' THEN 'A'
     WHEN h.start_date BETWEEN '1JAN1990' AND '12DEC1994' THEN 'B'
     WHEN h.start_date>'12DEC1994' THEN 'C' ELSE 'NO GROUP' END
FROM employees e
LEFT JOIN job_history h
ON e.employee_id = h.employee_id;


SELECT
e.first_name  || ' ' || e.last_name,
CASE WHEN lower(j.job_title) LIKE '%president%' THEN 'President'
     WHEN lower(j.job_title) LIKE '%manager%' THEN 'Manager' ELSE 'Other' END
FROM employees e
JOIN jobs j
ON e.job_id = j.job_id;


SELECT first_name, reverse(first_name) FROM employees
WHERE lower(first_name) = reverse(lower(first_name));

SELECT
substr(first_name,3) || '_' || substr(last_name,3)
FROM employees;

SELECT * FROM employees
WHERE lower(first_name) = lower(reverse(first_name));

SELECT first_name, reverse(first_name) FROM employees;


SELECT 
phone_number,
length(phone_number),
substr(phone_number,1,4)||'xxx.xxx' ||substr(phone_number,-1) as "Phone",
RPAD (first_name || ' ' || last_name,20,' ') as "Full Name"
FROM employees;


SELECT * FROM locations
WHERE length(postal_code)>=5
AND
substr(postal_code,1,2)*1 BETWEEN 50 AND 99;

SELECT 
substr(postal_code,1,2) FROM locations
WHERE length(postal_code)>=5;


SELECT 
postal_code,
substr(postal_code,1,2) AS "Code",
substr(location_id,1,2)*1 
FROM locations;


SELECT 
job_id,
job_title,
min_salary,
max_salary,
round((max_salary - min_salary) / max_salary,2) as "Percentage"
FROM jobs;

SELECT
employee_id,
hire_date,
extract(year FROM trunc(sysdate)) - extract(year FROM hire_date) AS "Years Working",
extract(day FROM trunc(sysdate)) - extract(day FROM hire_date) AS "Wrong Calculation",
round( (trunc(sysdate) - hire_date)/365.2,3) as "Rounded Diffrence"
FROM employees;


SELECT 
start_date,
end_date,
extract(day FROM end_date) AS "Last Days",
last_day(start_date) "EOM",
last_day(start_date) - start_date "Days Served first Month"
FROM job_history;

SELECT 
start_date,
CASE WHEN  
           extract(month FROM start_date) =2 AND extract(day FROM last_day(start_date))=29 
           THEN 'Leap Year' ELSE 'Not Leap Year' END
FROM job_history;


SELECT 
start_date,
add_months(start_date,35*12) "Retire Date",
department_id
FROM job_history
ORDER BY department_id DESC,extract(month FROM start_date) ASC;

SELECT distinct * FROM sales;
SELECT distinct(order_date) FROM sales;
SELECT distinct customer_id, game_id FROM sales;


SELECT customer_id, game_id
FROM (
    SELECT DISTINCT customer_id 
    FROM sales
) 
CROSS JOIN (
    SELECT DISTINCT game_id 
    FROM sales
);


SELECT 
count(employee_id),
sum(salary),
round(avg(salary),0),
max(salary),
min(salary),
mod(min(salary),2000) "Moding"
FROM employees;

SELECT 
employee_id,
min(start_date-50)
FROM job_history
group by employee_id;

-- double column expression
SELECT * FROM job_history
WHERE (start_date,department_id) =     
                (SELECT min(start_date),department_id FROM job_history 
                WHERE department_id = 80
                group by department_id); 

SELECT 
max(e.salary),
min(e.salary),
max(j.max_salary),
min(j.min_salary) FROM employees e
JOIN jobs j
ON e.job_id = j.job_id;

SELECT count(employee_id) FROM employees
WHERE manager_id = 114;

SELECT count(distinct employee_id) FROM employees;


SELECT * FROM employees
WHERE employee_id>manager_id;

SELECT
region_id,
listagg(country_id,', ') within group (ORDER BY country_name)
FROM countries
group by region_id;

SELECT * FROM countries;

SELECT
start_date,
extract(month FROM start_date) AS "Month N",
mod(extract(month FROM start_date),2) "MD"
 FROM job_history;

SELECT 
 CASE WHEN mod(extract(month FROM start_date),2)=0 
   THEN 'EVEN' ELSE 'ODD' END AS "Naming",
 count(start_date) AS "Cnt"
 FROM job_history
 GROUP BY CASE WHEN mod(extract(month FROM start_date),2)=0 
    THEN 'EVEN' ELSE 'ODD' END;
 
SELECT
d.department_name,
count(distinct e.manager_id) "Unique Managers"
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
group by d.department_name
ORDER BY "Unique Managers" DESC;

SELECT
extract(year FROM hire_date) AS "Year",
count(employee_id)
FROM employees
GROUP BY extract(year FROM hire_date)
ORDER BY "Year";

SELECT 
      CASE WHEN j.max_salary - j.min_salary BETWEEN 0 AND 10000 THEN '0-10K'
        WHEN j.max_salary - j.min_salary BETWEEN 10001 AND 15000 THEN '10k-15K' ELSE '15K+' END AS "Category",
          COUNT(e.employee_id) AS "Cnt"
          FROM employees e
          JOIN jobs j
          ON e.job_id = j.job_id
          GROUP BY 
          CASE WHEN j.max_salary - j.min_salary BETWEEN 0 AND 10000 THEN '0-10K'
               WHEN j.max_salary - j.min_salary BETWEEN 10001 AND 15000 THEN '10k-15K' ELSE '15K+' END
               ORDER BY "Cnt" DESC;


SELECT
c.country_name,
count(l.location_id) AS "Locations"
FROM countries c
JOIN locations l
ON c.country_id = l.country_id
group by c.country_name;


SELECT
substr(first_name,1,1) AS "Letter",
Count(first_name) AS "Cnt"
FROM employees 
group by substr(first_name,1,1)
ORDER BY "Letter"; -- it is case sensitive


  -- Same as Recursive CTE
  -- CONNECT and LEVEL BY for Oracle
  -- It is also called hierarchical Queries
CREATE TABLE letters_table AS
SELECT CHR(64 + LEVEL) AS letter
FROM DUAL
CONNECT BY LEVEL <= 26;

SELECT * FROM letters_table;

-- Cool Bro
SELECT 
l.letter,
NVL(sum(c."Cnt"),0)
FROM letters_table l
LEFT JOIN 
        (SELECT
        substr(first_name,1,1) AS "Letter",
        Count(first_name) AS "Cnt"
        FROM employees 
        group by substr(first_name,1,1)) c
        ON l.letter = c."Letter"
        group by l.letter
        ORDER BY l.letter;

SELECT
job_id,
department_id,
count(employee_id)
FROM employees
group by job_id,department_id;

SELECT 
extract(year FROM end_date) "Year",
extract(month FROM end_date) "Month",
Count(employee_id)
FROM job_history
GROUP BY extract(year FROM end_date),extract(month FROM end_date)
ORDER BY "Year" ASC,"Month" ASC ;


SELECT
manager_id
FROM employees
group by manager_id
having count(employee_id)>=5
ORDER BY manager_id;

SELECT 
department_id
FROM employees
GROUP BY department_id
having sum(salary)>100000;

SELECT
department_id,
count(employee_id) AS Cnt
FROM employees
WHERE job_id<>'AD_PRESS'
GROUP BY department_id
HAVING count(employee_id)>=5
ORDER BY CNT; 

SELECT 
substr(phone_number,1,3),
listagg(employee_id,'|') within group (ORDER BY employee_id ASC) AS "List",
sum(salary)
FROM employees
WHERE department_id NOT IN (10,20,60)
GROUP BY substr(phone_number,1,3)
HAVING sum(salary)>50000;

SELECT
extract(year FROM hire_date) Year,
extract(month FROM hire_date) month,
count(employee_id)
FROM employees
group by 
extract(year FROM hire_date),
extract(month FROM hire_date)
HAVING count(employee_id)>=3
ORDER BY year,month;

-- Joins


SELECT 
e.first_name || ' ' || e.last_name AS "Full Name",
j.job_title 
FROM employees e
JOIN jobs j
ON e.job_id = j.job_id;

-- Self Join

SELECT
e.first_name || ' ' || e.last_name AS "Employee Name",
m.first_name || ' ' || m.last_name AS "Manager Name"
FROM employees e
JOIN employees m
ON e.manager_id = m.employee_id;

SELECT 
d.department_name,
e.first_name || ' '||e.last_name "Manager name"
FROM departments d
JOIN employees e
ON d.manager_id = e.manager_id;


SELECT
e.first_name || ' ' || e.last_name AS "Employee Name",
m.first_name || ' ' || m.last_name AS "Manager Name",
e.salary "E Salary",
m.salary "M Salary"
FROM employees e
JOIN employees m
ON e.manager_id = m.employee_id;


-- Manager's Manager

SELECT
e.first_name || ' ' || e.last_name AS "Employee Name",
m.first_name || ' ' || m.last_name AS "Manager Name",
s.first_name || ' ' || s.last_name AS "Managers Manager Name"
FROM employees e
LEFT JOIN employees m
ON e.manager_id = m.employee_id
LEFT JOIN employees s
ON m.manager_id = s.employee_id;



-- Joined after manager

SELECT 
e.first_name || ' ' || e.last_name AS "Employee Name",
m.first_name || ' ' || m.last_name AS "Manager Name",
e.hire_date,
m.hire_date
FROM employees e
JOIN employees m
ON e.manager_id = m.employee_id
WHERE e.hire_date>m.hire_date;

-- Less salary than other employees

SELECT 
e.first_name || ' ' || e.last_name AS "Employee Name",
m.first_name || ' ' || m.last_name AS "Other Employees",
e.salary,
m.salary
FROM employees e
JOIN employees m
ON e.salary<m.salary 
ORDER by e.employee_id ASC;

-- Hire after him

SELECT 
e.first_name || ' ' || e.last_name AS "Employee Name",
m.first_name || ' ' || m.last_name AS "Other Employees",
e.hire_date,
m.hire_date
FROM employees e
JOIN employees m
ON e.hire_date<m.hire_date
ORDER by e.employee_id;


SELECT * FROM locations;
SELECT * FROM countries;
SELECT * FROM regions;

-- Continents and total employees

SELECT
r.region_name,
count(e.employee_id) 
FROM regions r
LEFT JOIN countries c
ON r.region_id = c.region_id
LEFT JOIN locations l
ON c.country_id = l.country_id
LEFT JOIN departments d
ON l.location_id = d.location_id
LEFT JOIN employees e
ON d.department_id = e.department_id
group by r.region_name;


-- Department and Ex-Employees
SELECT * FROM job_history;



SELECT 
d.department_name,
(SELECT count(job_id) FROM job_history
WHERE department_id = d.department_id)
FROM departments d
WHERE 
(SELECT count(job_id) FROM job_history 
WHERE department_id = d.department_id)
   <>0;



SELECT
d.department_name,
count(j.employee_id)
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id
LEFT JOIN job_history j
ON e.employee_id = j.employee_id
WHERE j.end_date<=trunc(sysdate)
group by d.department_name;

 -- Check above information
 SELECT department_id, employee_id FROM employees
 INTERSECT
 SELECT department_id, employee_id FROM job_history;    

 SELECT count(*) FROM job_history;


SELECT 
d.department_name,
count(j.employee_id)
FROM departments d
LEFT JOIN job_history j
ON d.department_id = j.department_id
WHERE j.end_date<=trunc(sysdate)
group by d.department_name;

-- Comparing table results
SELECT
j.employee_id,
j.department_id,
e.employee_id,
e.department_id
FROM job_history j
LEFT JOIN employees e
ON j.employee_id = e.employee_id; 


-- Manager and Supervision Counting

SELECT 
m.employee_id AS "Manager Id",
m.first_name || ' ' || m.last_name "Manager Name",
count(e.employee_id)
FROM employees m
JOIN employees e
ON m.employee_id = e.manager_id
GROUP BY 
m.employee_id,
m.first_name || ' ' || m.last_name
ORDER BY count(e.employee_id) DESC;

-- Higher salary than manager

SELECT 
m.employee_id AS "Manager Id",
m.first_name || ' ' || m.last_name "Manager Name",
nvl(count(e.employee_id),0)
FROM employees m
LEFT JOIN employees e
ON m.employee_id = e.manager_id  AND m.salary<e.salary
GROUP BY 
m.employee_id,
m.first_name || ' ' || m.last_name
ORDER BY count(e.employee_id) DESC;


-- Employees and count who receives lower salary than him

SELECT
e.employee_id,
e.first_name || ' '|| e.last_name "Employee Name",
Count(o.employee_id) Cnt 
FROM employees e
LEFT JOIN employees o
ON e.salary>o.salary
GROUP BY
e.employee_id ,
e.first_name || ' '|| e.last_name
ORDER BY Cnt ASC;

-- Checker (MIN/MAX)
SELECT * FROM employees
WHERE salary = (SELECT min(salary ) FROM employees);

SELECT * FROM employees
WHERE salary = (SELECT max(salary ) FROM employees);

-- Min Employee Checker

SELECT
e.employee_id,
e.first_name || ' '|| e.last_name "Employee Name",
o.employee_id
FROM employees e
LEFT JOIN employees o
ON e.salary>o.salary
WHERE e.employee_id = 132
order BY o.employee_id ASC;


-- Employees and hired before him

SELECT
e.employee_id,
e.first_name || ' '|| e.last_name "Employee Name",
Count(o.employee_id) Cnt 
FROM employees e
LEFT JOIN employees o
ON e.hire_date>o.hire_date
GROUP BY
e.employee_id ,
e.first_name || ' '|| e.last_name
order BY Cnt ASC;


SELECT * FROM employees
WHERE hire_date = (SELECT min(hire_date) FROM employees);








