
SELECT job_id, avg(salary) FROM employees
GROUP BY job_id
ORDER BY avg(salary) DESC;


SELECT job_id,manager_id, avg(salary)
FROM employees
GROUP BY job_id,department_id,manager_id
order by count(*) DESC; 


SELECT last_day(sales_date),Count(distinct game_id) FROM sales
GROUP BY last_day(sales_date)
order by Count(distinct game_id) DESC;

-- one of the challenge FROM the course
SELECT last_day(sales_date),Count(game_id) FROM sales
GROUP BY last_day(sales_date)
order by Count(game_id) DESC;


-- Having Clause
SELECT 
game_id,
round(avg(sales_units),2) AS "Avg Units",
count(*),
max(sales_units)
FROM sales
WHERE sales_units>150
GROUP BY game_id
having avg(sales_units)>175
order by avg(sales_units);


SELECT 
job_id,
avg(salary),
count(*)
FROM employees
GROUP BY job_id
having avg(salary)>10000 AND count(*)>1
order by avg(salary) DESC;


SELECT 
job_id,
avg(salary)
FROM employees
WHERE salary>16000
having avg(salary)>10000
GROUP BY job_id;


SELECT
department_id,
count(Job_id) 
FROM employees
GROUP BY department_id
having count(job_id)>5
order by count(job_id) ASC;


-- nested group functions
  -- Aggregation over aggregation
SELECT 
department_id,
avg(salary) 
FROM employees
GROUP BY department_id;

-- maximum FROM average salaries, can use deparment_id in SELECT statement
SELECT
max(avg(salary)),
min(avg(salary)) 
FROM employees
GROUP BY department_id;

SELECT
sales_date,
order_date,
to_char(sales_date,'WW'), -- week Num
to_char(sales_date,'DD'),
trunc(sysdate) - trunc(sysdate,'YEAR')+1 "Days Passed"
FROM sales;




