﻿
-- DML - Data manipulation language
   -- Data Engineer-ების და DataBase Developer
 
-- add new rows, delete or update
-- insert, update, delete, merge
-- Transaction concept, all should be succesful
-- COMMIT and RollBack

   -- Insert Statement 1

CREATE TABLE jobs_copy AS SELECT * FROM jobs;

-- General Statement of inserting
   -- values should be same data type as columns
INSERT INTO jobs_copy (job_id, job_title, min_salary, max_salary)
VALUES('GR_LDR', 'Group Leader', 8500, 20000);
 -- unpecified column values will be filled with NULL or default value

INSERT INTO jobs_copy (job_id, job_title, min_salary, max_salary)
VALUES('PR_MGR', 'Project Manager', 7000, 18000);

INSERT INTO jobs_copy (job_title, min_salary, job_id, max_salary)
VALUES('Architect',6500,'ARCH',15000);


INSERT INTO jobs_copy
VALUES('DATA_ENG','Data Engineer',8000,21000);


INSERT INTO jobs_copy
VALUES('DATA_ENG','Data Engineer',8000);

INSERT INTO jobs_copy (job_id, job_title, min_salary)
VALUES('DATA_ARCH','Data Architecture',8000);

ALTER TABLE jobs_copy MODIFY max_salary DEFAULT 10000;
-- 10,000  Max Salary
SELECT * FROM jobs_copy;


INSERT INTO jobs_copy (job_id, min_salary)
VALUES('DATA_ARCH2',8000);

-- In NOT NULL value can't be inserted NULL, default



   -- Insert Statement 2

SELECT * FROM jobs_copy;


INSERT INTO jobs_copy
VALUES('DATA_ARCH3','Data Architecture3',8000, NULL);
 

INSERT INTO jobs_copy
VALUES('DATA_ARCH4',upper('Data Architecture4'),8000, NULL);


CREATE TABLE  hr_dt AS SELECT hire_date FROM employees;

INSERT INTO hr_dt (Hire_date)
VALUES(sysdate);

SELECT * FROM hr_dt
ORDER BY hire_date DESC;

DROP table employee_copy;

 
CREATE TABLE employees_copy AS SELECT * FROM employees;
 
SELECT * FROM employees_copy;
 
-- N of columns and data types should match
INSERT INTO employees_copy SELECT * FROM employees;




-- any SELECT statment can be inserted 
INSERT INTO employees_copy SELECT * FROM employees WHERE job_id = 'IT_PROG'; 

-- Specifying Column list to insert, დანარჩენებს Value
INSERT INTO employees_copy(first_name,last_name,email,hire_date,job_id)
SELECT first_name,last_name,email,hire_date,job_id FROM employees WHERE job_id = 'IT_PROG';

SELECT * FROM employees_copy;

-- Just creating table without rows in it (using WHERE 1=2)
CREATE TABLE employee_addresses AS
SELECT employee_id, first_name, last_name, city || ' - ' || street_address AS address
  FROM employees
  JOIN departments  USING (department_id) 
  JOIN locations    USING (location_id)
WHERE 1=2;

 -- Inserting values in it
INSERT INTO employee_addresses 
SELECT employee_id, first_name, last_name, city || ' - ' || street_address AS address
  FROM employees
  JOIN departments  USING (department_id) 
  JOIN locations    USING (location_id);
 
SELECT * FROM employee_addresses;

  -- Multitable insert Statements
  -- INSERT ALL statement

  -- Unconditional

--Creates the employees_history table with no data based on the employees table
CREATE TABLE employees_history AS 
    SELECT employee_id, first_name, last_name, hire_date 
    FROM employees WHERE 1=2;

SELECT * FROM employees_history;
    
--Creates the salary_history table with no data based on the employees table
--1234 and 12 are just ordinary numbers, to make the data type of these columns number
CREATE TABLE salary_history AS
    SELECT employee_id, 1234 AS year, 12 AS month, salary, commission_pct
    FROM employees WHERE 1=2;

SELECT * FROM salary_history;

 
--Inserts all the returning rows into two different tables in one step
 
 INSERT ALL
  INTO employees_history VALUES (employee_id,first_name,last_name,hire_date)
  INTO salary_history VALUES (employee_id, EXTRACT(year FROM sysdate),    
  EXTRACT(month FROM sysdate),salary, commission_pct)
SELECT * FROM employees WHERE hire_date> TO_DATE('15-MAR-08');
 

SELECT * FROM employees_history; 
SELECT * FROM salary_history;

INSERT ALL
  INTO employees_history 
  SELECT employee_id,first_name,last_name,hire_date FROM employees WHERE hire_date> TO_DATE('15-MAR-08');
 
--Insert multiple rows into the same table, with static values
INSERT ALL
  INTO employees_history VALUES (105,'Adam','Smith',sysdate)
  INTO employees_history VALUES (106,'Paul','Smith',sysdate+1)
SELECT * FROM dual; 

COMMIT;

    -- Conditional Insert Statement


--Creates a table called it_programmers with no data based on the employees table columns
CREATE TABLE it_programmers AS 
    SELECT employee_id, first_name, last_name, hire_date FROM employees WHERE 1=2;
 
SELECT * FROM it_programmers;
--Creates a table called working_in_us with no data based on the employees table columns
CREATE TABLE working_in_the_us AS 
    SELECT employee_id, first_name, last_name, job_id, department_id FROM employees WHERE 1=2;

SELECT * FROM working_in_the_us;

-- just testing
SELECT 
'15MAR18',
to_date('15MAR18'),
CASE WHEN '15MAR18'=to_date('15MAR18') THEN 1 else 0 end
FROM dual;

-- Conditional inserting 
-- WHEN Columns are FROM SELECT Query
INSERT ALL
 WHEN hire_date > to_date('15-MAR-08') THEN
  INTO employees_history VALUES (employee_id,first_name,last_name,hire_date)
  INTO salary_history VALUES (employee_id, EXTRACT(year FROM sysdate),    
  EXTRACT(month FROM sysdate),salary, commission_pct)
 WHEN job_id = 'IT_PROG' THEN
  INTO it_programmers VALUES(employee_id,first_name,last_name,hire_date)
 WHEN department_id IN 
    (SELECT department_id FROM departments WHERE location_id IN
        (SELECT location_id FROM locations WHERE country_id = 'US')) THEN
  INTO working_in_the_us VALUES (employee_id,first_name,last_name,job_id,department_id)
SELECT * FROM employees;
 
-- changes on tables
-- one row FROM SELECT can be inserted in multiple tables, because it satisfies multiple conditions
SELECT * FROM it_programmers;
SELECT * FROM working_in_the_us;
SELECT * FROM employees_history;

-- Else Statement, rows that don't stisfy any condition 
INSERT ALL
 WHEN hire_date > to_date('15-MAR-08') THEN
  INTO salary_history VALUES (employee_id, EXTRACT(year FROM sysdate),    
  EXTRACT(month FROM sysdate),salary, commission_pct)
 WHEN job_id = 'IT_PROG' THEN
  INTO it_programmers VALUES(employee_id,first_name,last_name,hire_date)
 WHEN department_id IN 
    (SELECT department_id FROM departments WHERE location_id IN
        (SELECT location_id FROM locations WHERE country_id = 'US')) THEN
  INTO working_in_the_us VALUES (employee_id,first_name,last_name,job_id,department_id)
 ELSE
  INTO employees_history VALUES (employee_id,first_name,last_name,hire_date)
SELECT * FROM employees;
 

INSERT ALL
 WHEN hire_date > to_date('15-MAR-08') THEN
  INTO salary_history VALUES (employee_id, EXTRACT(year FROM sysdate),    
  EXTRACT(month FROM sysdate),salary, commission_pct)
 WHEN 1=1 THEN
  INTO it_programmers VALUES(employee_id,first_name,last_name,hire_date)
 WHEN department_id IN 
    (SELECT department_id FROM departments WHERE location_id IN
        (SELECT location_id FROM locations WHERE country_id = 'US')) THEN
  INTO working_in_the_us VALUES (employee_id,first_name,last_name,job_id,department_id)
 ELSE
  INTO employees_history VALUES (employee_id,first_name,last_name,hire_date)
SELECT * FROM employees;


-- Conditional Insert First


--Creates a table called low_salaries with no data based on the employees table columns
CREATE TABLE low_salaries AS 
    SELECT employee_id, department_id, salary FROM employees WHERE 1=2;
 
--Creates a table called average_salaries with no data based on the employees table columns
CREATE TABLE average_salaries AS 
    SELECT employee_id, department_id, salary FROM employees WHERE 1=2;
    
--Creates a table called high_salaries with no data based on the employees table columns
CREATE TABLE high_salaries AS 
    SELECT employee_id, department_id, salary FROM employees WHERE 1=2;
 
 -- all rows are added FROM employees table in those 3 tables
SELECT * FROM low_salaries;
SELECT * FROM average_salaries;
SELECT * FROM high_salaries;

INSERT FIRST
   WHEN salary<5000 THEN
      INTO low_salaries VALUES(employee_id, department_id, salary)
   WHEN salary BETWEEN 5000 AND 10000 THEN
      INTO average_salaries VALUES(employee_id, department_id, salary)
   ELSE 
      INTO high_salaries VALUES(employee_id, department_id, salary)
SELECT * FROM employees;


  -- Pivot Inserting (Type of Unconditional insert statement)
  
CREATE TABLE emp_sales (employee_id     NUMBER(6),
                        week_id         NUMBER(2),
                        sales_mon       NUMBER,
                        sales_tue       NUMBER,
                        sales_wed       NUMBER,
                        sales_thu       NUMBER,
                        sales_fri       NUMBER);
 
CREATE TABLE emp_sales_normalized (employee_id     NUMBER(6),
                                   week_id         NUMBER(2),
                                   sales           NUMBER,
                                   day             VARCHAR2(3));

INSERT ALL
    INTO emp_sales VALUES (105,23,2500,3200,4700,5600,2900)
    INTO emp_sales VALUES (106,24,2740,3060,4920,5650,2800)
SELECT * FROM dual;
                                
SELECT * FROM emp_sales;
SELECT * FROM emp_sales_normalized;


INSERT ALL
    INTO emp_sales_normalized VALUES (employee_id, week_id, sales_mon, 'MON')
    INTO emp_sales_normalized VALUES (employee_id, week_id, sales_tue, 'TUE')
    INTO emp_sales_normalized VALUES (employee_id, week_id, sales_wed, 'WED')
    INTO emp_sales_normalized VALUES (employee_id, week_id, sales_thu, 'THU')
    INTO emp_sales_normalized VALUES (employee_id, week_id, sales_fri, 'FRI')
SELECT * FROM emp_sales;


   -- Update Statement
   
DROP TABLE employees_copy;
CREATE TABLE employees_copy AS SELECT * FROM employees;
 
SELECT * FROM employees_copy;
 
-- All rows updated
UPDATE employees_copy 
SET salary = 500;
 
SELECT * FROM employees_copy WHERE job_id = 'IT_PROG';
 
UPDATE employees_copy 
SET salary = 50000
WHERE job_id = 'IT_PROG';

-- Update multiple columns 
UPDATE employees_copy 
SET salary = 5, department_id = null
WHERE job_id = 'IT_PROG';

-- number of columns and data types should match
-- should be single row subqery
UPDATE employees_copy 
SET (salary, commission_pct) = (SELECT max(salary), max(commission_pct) FROM employees)
WHERE job_id = 'IT_PROG';
 
-- most recently hired employee salary update
UPDATE employees_copy
SET    salary    = 100000
WHERE  hire_date = (SELECT MAX(hire_date) FROM employees);

-- DELETE Statement

SELECT * FROM employees_copy;
 
DELETE FROM employees_copy;

DELETE employees_copy;
ROLLBACK;

DELETE employees_copy
WHERE job_id = 'IT_PROG';
 
-- Delete based on SubQuery
DELETE employees_copy
WHERE department_id IN (SELECT department_id 
                        FROM departments 
                        WHERE upper(department_name) LIKE'%SALES%'); -- Good Technique
                        

 -- MERGE Statement
  -- INSERT, UPDATE, DELETE
  
SELECT * FROM employees_copy;
DELETE FROM employees_copy;
INSERT INTO employees_copy SELECT * FROM employees WHERE job_id = 'SA_REP';
UPDATE employees_copy SET first_name = 'Alex';
 
MERGE INTO employees_copy c
USING (SELECT * FROM employees) e 
ON (c.employee_id = e.employee_id)
WHEN MATCHED THEN
   UPDATE SET
      c.first_name = e.first_name,
      c.last_name = e.last_name,
      c.department_id = e.department_id,
      c.salary = e.salary
   DELETE WHERE department_id IS NULL -- When it is matched and Department_id IS NULL, then delete those rows
WHEN NOT MATCHED THEN
   INSERT 
   VALUES(e.employee_id, e.first_name, e.last_name, e.email, 
   e.phone_number, e.hire_date, e.job_id, e.salary, e.commission_pct, 
   e.manager_id, e.department_id);
 
-- Filtering source table with WHERE
-- Source table might be View, Table or SubQuery
MERGE INTO employees_copy c
USING (SELECT * FROM employees WHERE job_id = 'IT_PROG') e
ON (c.employee_id = e.employee_id)
WHEN MATCHED THEN
   UPDATE SET
      c.first_name = e.first_name,
      c.last_name = e.last_name,
      c.department_id = e.department_id,
      c.salary = e.salary
   DELETE WHERE department_id IS NULL
WHEN NOT MATCHED THEN
   INSERT 
   VALUES(e.employee_id, e.first_name, e.last_name, e.email, 
   e.phone_number, e.hire_date, e.job_id, e.salary, e.commission_pct, 
   e.manager_id, e.department_id);
 
-- WHEN MATCHED or WHEN NOT MATCHED are not neccesary to use both, one of them or both of them
MERGE INTO employees_copy c
USING employees e
ON (c.employee_id = e.employee_id)
WHEN MATCHED THEN
   UPDATE SET
      c.first_name = e.first_name,
      c.last_name = e.last_name,
      c.department_id = e.department_id,
      c.salary = e.salary
   DELETE WHERE department_id IS NULL
WHEN NOT MATCHED THEN
   INSERT 
   VALUES(e.employee_id, e.first_name, e.last_name, e.email, 
   e.phone_number, e.hire_date, e.job_id, e.salary, e.commission_pct, 
   e.manager_id, e.department_id);
 
-- Increases Performance compared to indepdendenlty doing: DELETE, UPDATE, INSERT


  -- Transaction Control Language(TCL)
-- Transaction Control Statements are: COMMIT, RollBack, SavePoint  

   -- COMMIT and ROLLBACK

ROLLBACK; -- UNDOS all all DML statements

COMMIT;

SELECT * FROM employees_copy;
DELETE employees_copy WHERE job_id = 'SA_REP';

SELECT * FROM employees_copy;
DELETE employees_copy WHERE job_id = 'SA_REP';

ROLLBACK;

UPDATE employees_copy SET first_name = 'John';
COMMIT;

UPDATE employees_copy c 
SET first_name = 
    (SELECT first_name FROM employees e
     WHERE e.employee_id = c.employee_id);
INSERT INTO employees_copy
    (SELECT * FROM employees
     WHERE job_id = 'SA_REP');
CREATE TABLE temp (tmp DATE);

DROP TABLE temp;

 -- DDL - Create, DROP, Alter, Modify


UPDATE employees_copy
SET salary = salary + 500
WHERE employee_id = 102;
 
SELECT employee_id,first_name,last_name,salary 
FROM employees_copy 
WHERE employee_id = 102;  
 
UPDATE employees_copy
SET salary = salary + 500
WHERE employee_id = 103;
 
UPDATE hr.employees_copy
SET salary = salary + 1000
WHERE employee_id = 102;
 
  
UPDATE employees_copy
SET first_name = 'Alex'
WHERE employee_id = 102;
 
 
 
 -- SavePoint Statement
    -- RollBack at some point

SELECT * FROM employees_copy;
SELECT * FROM jobs_copy;
 
 --DML 1
DELETE FROM employees_copy WHERE job_id = 'IT_PROG';
SAVEPOINT A; --> Creates SavePoint A
--DML 2
UPDATE employees_copy 
SET salary = 1.2 * salary;
SAVEPOINT B; --> Creates SavePoint B
--DML 3
INSERT INTO jobs_copy VALUES ('PY_DEV','Python Developer', 12000, 20000);
SAVEPOINT C; --> Creates SavePoint C
--DML 4
DELETE FROM employees_copy WHERE job_id = 'SA_REP';
SAVEPOINT D; --> Creates SavePoint D
 
--Rollbacks All
ROLLBACK;
--Rollbacks to SavePoint "B"
ROLLBACK TO B;
 
--Rollbacks to SavePoint "C"
ROLLBACK TO C;
 
--Rollbacks to SavePoint "A"
ROLLBACK TO SAVEPOINT A;
 
 

 -- For UPDATE Statement 


--CODE TO EXECUTE WITH HR
SELECT * FROM employees_copy
WHERE job_id = 'IT_PROG' FOR UPDATE; 
 

SELECT first_name, last_name, salary
FROM employees_copy e JOIN departments d
USING(department_id) 
WHERE location_id = 1400 
FOR UPDATE; 
 

SELECT first_name, last_name, salary
  FROM employees_copy e JOIN departments d
  USING(department_id) 
  WHERE location_id = 1400
  FOR UPDATE OF first_name, last_name,department_id; 

COMMIT;

SELECT first_name, last_name, salary
  FROM employees_copy e JOIN departments d
  USING(department_id) 
  WHERE location_id = 1400
  FOR UPDATE OF first_name, location_id NOWAIT; 
 
SELECT first_name, last_name, salary
  FROM employees_copy e JOIN departments d
  USING(department_id) 
  WHERE location_id = 1400
  FOR UPDATE OF first_name, location_id WAIT 5; 
 
SELECT first_name, last_name, salary
  FROM employees_copy e JOIN departments d
  USING(department_id) 
  WHERE location_id = 1400
  FOR UPDATE OF first_name SKIP LOCKED; 
 
 
 