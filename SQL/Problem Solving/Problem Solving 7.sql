
 -- Training Camp Solutions

SELECT 
e.first_name,
substr(e.first_name,1,1)||'.'||substr(e.last_name,1,1) initials,
next_day(hire_date,2) next_monday,
trunc(hire_date,'Month'),
round((trunc(sysdate) - hire_date)/7,0) Weeks,
round(months_between(sysdate,hire_date)/12,2) Years_dif,
hire_date,
  CASE WHEN to_char(hire_date,'mm-dd')<'08-25' THEN 1 ELSE 0 END + 
  CASE WHEN to_char(sysdate,'mm-dd')<'08-25' THEN 1 ELSE 0 END +
  months_between(trunc(sysdate,'YYYY'), trunc(add_months(hire_date,12),'YYYY'))/12  Bonuses,
floor(
 months_between(
  to_date(
  	   '22-MAR-'||to_char(add_months(hire_date,12),'YYYY'),'DD-MON-YYYY'), 
       hire_date)) Months_passed
FROM employees e
WHERE 1=1
AND
(
  lower(substr(e.first_name,1,1)) = lower(substr(e.first_name,-1,1))
   OR 
   lower(substr(e.first_name,1,1))<>lower(substr(e.last_name,1,1))
   	 AND length(email)>5);

  
  


SELECT 
phone_number,
job_id,
substr(replace(phone_number,'.',''),1,length(replace(phone_number,'.',''))-4)||'****' Phone,
substr(phone_number,instr(phone_number,'.',1,1)+1, instr(phone_number,'.',1,2) - instr(phone_number,'.',1,1)-1) Middle,
rpad(substr(job_id,1,instr(job_id,'_')),length(job_id),'*')
FROM employees;


SELECT 
hire_date,
salary,
floor(
CASE WHEN extract(day FROM sysdate)>=15 THEN Salary ELSE 0 END + 
CASE WHEN extract(day FROM hire_date)<15 THEN Salary ELSE 0 END
+ 1/12*salary*floor(
     months_between(trunc(sysdate,'Month'),trunc(add_months(hire_date,1),'Month')))) Annual_salary
FROM employees;

SELECT trunc(sysdate,'Month') FROM dual;



SELECT * FROM employees
ORDER BY 
extract( YEAR FROM hire_date) ASC,
commission_pct DESC NULLS FIRST,
phone_number DESC;

SELECT * FROM dual
WHERE 'A'='a'; 



SELECT
first_name,
last_name,
phone_number,
CASE WHEN mod(length(first_name),2)=0 THEN substr(first_name, length(first_name)/2,1) 
  ELSE substr(first_name,floor(length(first_name)/2)+1,1) END Middle1,
CASE WHEN mod(length(last_name),2)=0 THEN substr(last_name, length(first_name)/2,2) 
  ELSE substr(last_name,floor(length(last_name)/2)+1,1) END Middle2,
CASE WHEN mod(extract(month FROM hire_date) + extract(year FROM hire_date),1*substr(salary,1,1))=0 THEN email else phone_number end Casing,
round(salary*nvl(commission_pct,0.12)) Sal,
CASE WHEN extract(month FROM hire_date) = extract(month FROM next_day(hire_date,2)) 
  THEN upper(substr(first_name,1,1)) ELSE upper(substr(last_name,1,1)) END Upp_nm,
CASE WHEN (length(phone_number) - length(replace(phone_number,'.')))>2 THEN replace(phone_number,'.') ELSE phone_number END Ph,
CASE WHEN extract(month FROM hire_date) IN (11,12,1) THEN 'WInter' 
     WHEN extract(month FROM hire_date) IN (2,3,4) THEN 'Spinrg'
     WHEN extract(month FROM hire_date) IN (5,6,7) THEN 'Summer'
     ELSE 'Autumn' END "Time",
       
SELECT         
salary,
length(trunc(salary))
FROM employees;


SELECT * FROM employees
ORDER BY 
mod(length(first_name),2)*10+mod(length(last_name),2)*10 DESC,
mod(length(first_name),2)*100 DESC,
;

SELECT * FROM employees
ORDER BY CASE WHEN mod(employee_id,2)=1 THEN 1 else 0 END; 


SELECT salary FROM employees;
SELECT next_day('1JAN2024',2) FROM dual;

SELECT manager_id, avg(salary) FROM employees
WHERE employee_id>150
GROUP by manager_id;

SELECT job_id, avg(nvl(commission_pct,0)),avg(salary) FROM employees
GROUP BY job_id
ORDER BY avg(salary) desc; 


SELECT 
sum(CASE WHEN salary<5000 THEN 1 ELSE 0 END) "Under 5000",
sum(CASE WHEN salary BETWEEN 5000 AND 10000 THEN 1 ELSE 0 END) "BetWeen 5000 and 10000",
sum(CASE WHEN salary>10000 THEN 1 ELSE 0 END) "Above 10000"
FROM employees;

-- HomeWork 3


SELECT 
e.employee_id,
e.manager_id,
d.department_name,
l.city,
c.country_name,
r.region_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
JOIN locations l
ON d.location_id = l.location_id
JOIN countries c
ON l.country_id = c.country_id
JOIN regions r
ON c.region_id = r.region_id;



-- Order by
SELECT
e.employee_id,
(SELECT count(*) FROM job_history
WHERE employee_id = e.employee_id) "Dep Count",
CASE WHEN (SELECT count(*) FROM job_history
          WHERE employee_id = e.employee_id)=0 THEN department_id ELSE NULL END "Current Department"
FROM employees e
ORDER BY 
CASE WHEN "Dep Count">1 THEN 1 ELSE 0 END DESC,
  CASE WHEN "Current Department" IS NULL THEN 1 ELSE 0 END DESC,
    CASE WHEN "Dep Count"=1  THEN 1 ELSE 0 END DESC;


-- Assignment



SELECT job_id FROM employees e
WHERE 2<=(SELECT count(distinct department_id) FROM employees
                WHERE job_id = e.job_id);               

SELECT job_id FROM employees
GROUP BY job_id
having count(distinct department_id)=1 AND min(salary)>300; 


SELECT job_id,avg(salary) FROM employees e
  GROUP by Job_id
  HAVING( count(distinct department_id))=1
	AND 
     300<(SELECT min(salary) FROM employees WHERE job_id=e.job_id);
                 

SELECT count(distinct job_id) FROM employees;


  
SELECT * FROM employees
WHERE salary > (SELECT avg(salary) FROM employees);


 
SELECT * FROM employees e
WHERE exists (SELECT 1 FROM job_history WHERE employee_id = e.employee_id);



SELECT * FROM employees e
WHERE employee_id NOT IN (SELECT manager_id FROM employees
                          WHERE manager_Id IS NOT NULL)
AND salary >= ANY(SELECT salary FROM employees
           WHERE employee_id IN (SELECT manager_id FROM employees)); 

SELECT * FROM employees 
WHERE employee_id NOT IN (SELECT manager_id FROM employees
                       WHERE manager_id IS NOT NULL);   
   

SELECT * FROM employees e
WHERE salary > ANY(SELECT salary FROM employees
           WHERE employee_id IN (SELECT manager_id FROM employees)); 

SELECT * FROM employees
WHERE employee_id IN (SELECT manager_id FROM employees);

SELECT * FROM employees
WHERE employee_id > ANY (SELECT manager_id FROM employees);


SELECT 
Employee_id,
job_id,
manager_id,
first_name || ' '  || last_name AS Full_Name,
(SELECT count(*) FROM employees
WHERE job_id = e.job_id) "Cnt1",
COUNT(*) over(partition by job_id) AS "Cnt2",
(SELECT count(*) FROM employees    
  WHERE job_id = 
   (SELECT job_id FROM employees WHERE employee_id = e.manager_id)) "Man Job_id" 
      
FROM employees e;

  -- With Self JOIN

SELECT
e.employee_id,
e.job_id,
e.manager_id,
e.first_name || ' ' || e.last_name AS Full_Name,
count(*) over(partition by e.job_id) "Cnt1",
(SELECT count(*) FROM employees WHERE job_id = m.job_id) "Man Job_id"
FROM employees e
JOIN employees m
ON e.manager_id = m.employee_id;

 -- Checking
SELECT count(*) FROM employees
WHERE job_id = (SELECT job_id FROM employees
               WHERE employee_id=122);

SELECT 
e.employee_id,
c.country_name,
count(*) over(partition by c.country_name) "Country Employees" 
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
JOIN locations l
ON d.location_id = l.location_id
JOIN countries c
ON l.country_id = c.country_id
JOIN regions r
ON c.region_id = r.region_id
ORDER BY "Country Employees" DESC;
  
SELECT * FROM employees;


 
 
 
 

