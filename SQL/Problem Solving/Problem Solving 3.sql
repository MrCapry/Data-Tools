
-- Questions LINK: https://www.slideshare.net/ABHIJEETKHIRE/all-questions
  -- Total of 194 Questions
  

-- Employee, department name of employee and manager phone
SELECT
e.first_name || ' '||e.last_name "Employee Name",
d.department_name "Department",
m.phone_number "Manager Phone"
FROM employees e
JOIN employees m
ON e.manager_id = m.employee_id
JOIN departments d
ON e.department_id = d.department_id;


SELECT
e.first_name || ' ' || e.last_name ||' Works at '||
d.department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;

-- Employees who are managers also

   -- Where EXISTS

SELECT * FROM employees
WHERE employee_id IN (SELECT manager_id FROM employees);

-- Clerks

SELECT * FROM employees
WHERE lower(job_id) LIKE '%clerk%';


-- Hired in 1980 to 2020

SELECT * FROM employees
WHERE extract(year FROM hire_date) BETWEEN 1980 and 2020;

-- 2a in name

SELECT * FROM employees
WHERE lower(first_name) LIKE '%a%a%';

SELECT * FROM employees
WHERE (length(first_name) - length(replace(lower(first_name),'a','')))>=2;

-- Find
SELECT instr(job_id,'_') FROM employees;


SELECT * FROM employees;

SELECT
department_id,
sum(salary),
max(salary),
min(salary)
FROM employees
WHERE extract(year FROM hire_date) between 2000 and 2005
GROUP BY department_id;


SELECT * FROM employees
WHERE department_id IN
(SELECT department_id FROM employees
        WHERE lower(last_name)='smith' or lower(last_name) ='allen'); 

SELECT 
department_id,
count(job_id)
FROM employees
WHERE lower(job_id) LIKE '%clerk%'
GROUP BY department_id;


SELECT * FROM departments
WHERE manager_id IN
(SELECT manager_Id FROM employees
        WHERE lower(last_name)='ernst');

-- department with no employees
SELECT * FROM departments 
WHERE department_id NOT IN
 (SELECT department_id FROM employees
 WHERE department_id IS NOT NULL); 


-- Same with NOT EXISTS

SELECT * FROM departments d
WHERE  NOT EXISTS
 (SELECT * FROM employees
 WHERE department_id = d.department_id);

-- Second Maximum Salary

SELECT max(salary) FROM employees
WHERE salary <> (SELECT max(salary) FROM employees);

-- earning more than any manager


SELECT * FROM employees
WHERE salary >= ALL (SELECT salary FROM employees
                   WHERE employee_id IN (SELECT manager_id FROM employees));

-- Manager's who do not have managers
   
   
SELECT * FROM employees
WHERE 
employee_id IN (SELECT manager_id FROM employees)
AND manager_id IS NULL;

-- Same Hire_date

SELECT
e.first_name || ' '||e.last_name,
s.first_name || ' '||s.last_name,
e.hire_date,
s.hire_date
FROM employees e
JOIN employees s
ON e.employee_id<>s.employee_id AND e.hire_date = s.hire_date
order BY e.hire_date ASC;

-- better solution

SELECT
hire_date,
listagg(first_name || ' '|| last_name,', ') within group (ORDER BY employee_id)
FROM employees
GROUP by hire_date
HAVING count(employee_id)>1
ORDER BY hire_date ASC;


-- hire after smith and his department have at least 4 employee

SELECT * FROM employees
WHERE Hire_date > ANY 
(SELECT hire_date FROM employees
WHERE last_name='Smith')
AND department_id IN
(SELECT 
department_id
 FROM employees
 group by department_id
 having count(employee_id)>4);

-- Manager and employees hired same date

SELECT 
e.first_name ||' ' ||e.last_name "Employee",
m.first_name ||' ' ||m.last_name "Manager",
e.hire_date,
m.hire_date
FROM employees e
JOIN employees m
ON e.manager_id = m.employee_id AND e.hire_date = m.hire_date
ORDER BY e.hire_date ASC;

-- Working same location (two departments might have same locations)
  
  -- have same department
SELECT 
e.first_name ||' ' ||e.last_name "Employee",
m.first_name ||' ' ||m.last_name "Manager",
e.department_id,
m.department_id
FROM employees e
JOIN employees m
ON e.manager_id = m.employee_id AND e.department_id = m.department_id
ORDER BY e.hire_date ASC;


  -- have same location
   -- self join + 2 Joins for each Self, e and m

SELECT 
e.first_name ||' ' ||e.last_name "Employee",
m.first_name ||' ' ||m.last_name "Manager",
e.department_id,
m.department_id,
de.location_id,
dm.location_id
FROM employees e
JOIN employees m
ON e.manager_id = m.employee_id
JOIN departments de
ON e.department_id = de.department_id
JOIN departments dm
ON m.department_id = dm.department_id
WHERE de.location_id = dm.location_id
ORDER BY e.hire_date ASC;

SELECT * FROM departments;
 


-- MAN in Job_id
 
SELECT * FROM employees
WHERE (employee_id, job_id) IN
(SELECT manager_id,job_id FROM employees
WHERE lower(job_id) LIKE '%man%' AND  manager_id IS NOT NULL);


SELECT * FROM employees
WHERE employee_id IN
(SELECT manager_id FROM employees
WHERE manager_id IS NOT NULL) AND
lower(job_id) LIKE '%man%';


SELECT 
e.*,
instr(e.first_name,'S')
FROM employees e


-- Duplicated names
  SELECT
    first_name,
    count(first_name)
    FROM employees
    group by first_name
    having count(first_name)>1;

-- Listing employees with same names
SELECT
first_name,
count(first_name),
listagg(first_name || ' '||last_name,', ') within group (ORDER BY employee_id)
FROM employees
GROUP BY first_name
having count(first_name)>1;

-- Employees Experience

SELECT
first_name,
last_name,
round((trunc(sysdate) - hire_date)/365.25,2) "Experience"
FROM employees
ORDER BY "Experience" DESC;


-- Number of years experience in company

SELECT
SUM (round((trunc(sysdate) - hire_date)/365.25,2))
FROM employees;

-- Days left FROM current Month

SELECT
round(
last_day(sysdate) - trunc(sysdate),3) 
FROM dual;

        -- WeekDay
SELECT to_char(hire_date,'DAY') FROM employees;

SELECT 
first_name || ' '||last_name,
salary*12 + nvl(commission_pct*salary,0) AS "Payroll"
FROM employees
ORDER BY "Payroll" DESC;


SELECT 
last_day(s.sales_date),
sum(f.sales_units) "Current",
sum(s.sales_units) "Previous"
FROM sales f
JOIN sales s
ON s.sales_date BETWEEN last_day(add_months(f.sales_date,-2)) + 1 AND last_day(add_months(f.sales_date,-1))
  
 WHERE f.sales_date<='31DEC2011'
 group by last_day(s.sales_date)
 ORDER BY last_day(s.sales_date);
 
SELECT 
sales_date,
last_day(add_months(sales_date,-2))+1 "Start Date",
last_day(add_months(sales_date,-1))  "End Date"
FROM sales;

SELECT 
s.EOM,
s.sales,
d.sales FROM
  (SELECT
  last_day(sales_date) EOM,
  sum(sales_units) sales
  FROM sales
  GROUP BY last_day(sales_date)) s
FULL JOIN
  (SELECT
  last_day(add_months(sales_date,1)) EOM,
  sum(sales_units) sales
  FROM sales
  GROUP BY last_day(add_months(sales_date,1))) d
ON s.EOM = d.EOM
ORDER BY s.EOM;





