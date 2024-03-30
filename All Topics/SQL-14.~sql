
  -- Data Base Views:
  -- Base tables: views are based on them
  
  -- Hide sensitive information, not include some columns
  -- or restrict rows
  -- Using complext queries many places
  -- Presenting data in a different ways annual, etc..
  
  SELECT table_name FROM all_tables;
  
  SELECT * FROM my_employees;
  
  
  CREATE VIEW  Jobs_copy2 AS (SELECT * FROM jobs_copy);
  SELECT * FROM jobs_copy2;
  DROP Table jobs_copy;
  
  
  -- CREATE OR REPLACE --> create or modify existing one
  -- Forces to crete view even if base table doesn't exist
  -- NoForce is default
  -- WITH Check - prevents DML operations
  -- Read Only
  
-- Others users to see this result  
SELECT * FROM employees WHERE department_id = 90;
 
-- Creating View for that purpose
CREATE VIEW empvw90 AS
SELECT * FROM employees WHERE department_id = 90;
 
SELECT * FROM empvw90; -- use like a table
-- You can use any WHERE, GROUP BY, etc...
SELECT * FROM empvw90 WHERE salary < 20000;
 
-- Specifying Columns
CREATE VIEW empvw20 AS
SELECT employee_id, first_name, last_name FROM employees WHERE department_id = 20;

SELECT * FROM empvw20;
SELECT first_name, last_name FROM empvw20;
 
CREATE VIEW empvw30 AS
SELECT employee_id e_id, first_name name, last_name surname 
    FROM employees WHERE department_id = 30;

SELECT * FROM empvw30;

CREATE VIEW empvw40 (e_id, name, surname, email) AS
SELECT employee_id, first_name, last_name, email 
    FROM employees WHERE department_id = 40;

SELECT * FROM empvw40;
 

CREATE VIEW empvw41 (e_id, name, surname, email) AS
SELECT employee_id eid, first_name, last_name, email 
    FROM employees WHERE department_id = 40;

SELECT * FROM empvw41;
  
       -- Creating Complex Views
           
 CREATE VIEW emp_cx_vw (DNAME, MIN_SAL, MAX_SAL) AS
    SELECT distinct upper(department_name), min(salary), max(salary)
    FROM employees e JOIN departments d
    USING(department_id)
    GROUP BY department_name;

SELECT * FROM emp_cx_vw;  
 -- Diffrence with Easier views is DML operations sometimes

   -- Selecting with Distinct changes nothing in this case
 SELECT distinct department_id, min(salary), max(salary)
 FROM employees
 group by department_id;

 SELECT department_id, min(salary), max(salary)
 FROM employees
 group by department_id;
  
  -- Modifying Views
     -- DROP and Recreating it, but it is not best way to do it
     -- Privilages might loss
     -- Some others objects might have problems


  -- right click and VIEW, SELECT statement-ს ამოაგდებს View-ზე

CREATE OR REPLACE VIEW empvw30 AS
SELECT employee_id e_id, first_name name, last_name surname, job_id 
FROM employees WHERE department_id = 30;

-- Changed View 
SELECT * FROM empvw30;

CREATE OR REPLACE VIEW empvw30 AS
SELECT employee_id e_id, first_name||' '||last_name name, job_id 
FROM employees WHERE department_id = 30;
  
  
 -- Performing DML Operations With Views

-- if View is Complext than DML operations are not allowed
 
 -- Cascade Contraint-ების თემაში შედის რაც ნაკლებად მაინტერესებს
DROP TABLE employees_copy CASCADE CONSTRAINTS;
CREATE TABLE employees_copy AS SELECT * FROM employees;
 
-- Creating Simple View
CREATE VIEW empvw60 AS
SELECT employee_id, first_name, last_name, email, hire_date, job_id 
FROM employees_copy
WHERE department_id = 60;
 

SELECT * FROM employees_copy;
SELECT * FROM employees_copy WHERE department_id = 60;
  
INSERT INTO empvw60 VALUES (213,'Alex','Hummel','AHUMMEL',sysdate,'IT_PROG'); 


CREATE OR REPLACE VIEW empvw60 AS
SELECT employee_id, first_name, last_name, email, hire_date, job_id, department_id 
FROM employees_copy
WHERE department_id = 60;
  

SELECT * FROM empvw60;


INSERT INTO empvw60 VALUES (214,'Alex','Hummel','AHUMMEL',sysdate,'IT_PROG',60);

UPDATE empvw60 SET job_id = 'SA_MAN' WHERE employee_id = 214; 

DELETE FROM empvw60; 


CREATE OR REPLACE VIEW empvw60 AS
SELECT distinct employee_id, first_name, last_name, email, hire_date, job_id, department_id 
FROM employees_copy
WHERE department_id = 60;


CREATE OR REPLACE VIEW empvw60 AS
SELECT rownum rn, employee_id, first_name, last_name, email, hire_date, job_id, department_id 
FROM employees_copy
WHERE department_id = 60;
 

INSERT INTO empvw60 VALUES (1,214,'Alex','Hummel','AHUMMEL',sysdate,'IT_PROG',60);
 
CREATE OR REPLACE VIEW empvw60 AS
SELECT employee_id, first_name, last_name, email, hire_date, 
job_id, department_id, salary*12 annual_salary 
FROM employees_copy
WHERE department_id = 60;
 
-- Some DML operations are Allowed
INSERT INTO empvw60 VALUES (214,'Alex','Hummel','AHUMMEL',sysdate,'IT_PROG',60, 120000);
UPDATE empvw60 SET job_id = 'SA_MAN' WHERE employee_id = 107;
DELETE empvw60 WHERE employee_id = 107;

   -- Using Check Option

DROP TABLE employees_copy;
CREATE TABLE employees_copy AS SELECT * FROM employees;
 
-- Creating View
CREATE OR REPLACE VIEW empvw80 AS
    SELECT employee_id, first_name, last_name, email, hire_date, job_id
    FROM employees_copy
    WHERE department_id = 80;
 
SELECT * FROM empvw80;
 
 

INSERT INTO empvw80 VALUES (215,'John','Brown','JBROWN',sysdate,'SA_MAN');

SELECT * FROM employees_copy;
 
-- Creating VIEW with CHECK OPTION
CREATE OR REPLACE VIEW empvw80 AS
    SELECT employee_id, first_name, last_name, email, hire_date, job_id
    FROM employees_copy
    WHERE department_id = 80
WITH CHECK OPTION CONSTRAINT emp_dept80_chk; 


INSERT INTO empvw80 VALUES (216,'John2','Brown2','JBROWN2',sysdate,'SA_MAN');
 

CREATE OR REPLACE VIEW empvw80 AS
    SELECT employee_id, first_name, last_name, email, hire_date, job_id, department_id
    FROM employees_copy
    WHERE department_id = 80
WITH CHECK OPTION;
 

INSERT INTO empvw80 VALUES (217,'John3','Brown3','JBROWN3',sysdate,'SA_MAN', 80);

INSERT INTO empvw80 VALUES (218,'John4','Brown4','JBROWN4',sysdate,'SA_MAN', 60);
 -- other than department_id 80 is not allowed to inserted
 
 -- Id 80 და Job_id 'SA_MA'
CREATE OR REPLACE VIEW empvw80 AS
    SELECT employee_id, first_name, last_name, email, hire_date, job_id, department_id
    FROM employees_copy
    WHERE department_id = 80
    AND job_id = 'SA_MAN'
WITH CHECK OPTION;
 

INSERT INTO empvw80 VALUES (219,'John3','Brown3','JBROWN3',sysdate,'IT_PROG', 80);


UPDATE empvw80 SET first_name = 'Steve' WHERE employee_id = 217;

UPDATE empvw80 SET department_id = 70 WHERE employee_id = 217;
 
-- Data Dictionary View 
SELECT * FROM user_constraints WHERE table_name = 'EMPVW80';

SELECT * FROM all_views;


 -- Read-Only on Views
    -- Sometimes we don't want to use DML operations at all
     -- Read-only can't be used with Check Option

CREATE OR REPLACE VIEW empvw80 AS
SELECT employee_id, first_name, last_name, email, hire_date, job_id, department_id
FROM employees_copy
WHERE department_id = 80
AND job_id = 'SA_MAN'
WITH READ ONLY;
 
SELECT * FROM empvw80;
  

INSERT INTO empvw80 VALUES (219,'John3','Brown3','JBROWN3',sysdate,'IT_PROG', 80);
UPDATE empvw80 SET first_name = 'Steve' WHERE employee_id = 217;
DELETE FROM empvw80 WHERE employee_id = 217;
  
   
 -- Droping Views

DROP VIEW empvw20;
 
DROP VIEW empvw30;
 
DROP VIEW empvw40;
 
DROP VIEW empvw41;
 
DROP VIEW empvw60;
 
SELECT * FROM user_constraints WHERE table_name = 'EMPVW80';
 
DROP VIEW empvw80;

-- Contrains also droped
-- SomeTimes need to refresh
-- Righ click and drop option




