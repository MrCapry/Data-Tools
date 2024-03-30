﻿
       -- DDL (Data dDfinition Language)
-- CREATE, ALTER, DROP, TRUNCATE, COMMENT, RENAME

-- CAN USED ON:TABLES, INDEXES, VIEWS, SEQUENCES
-- COMMIT operation
-- DDL is auto-commited

-- start with letter
-- can't have same name as their type of object
-- only containts:A-Z,a-z,0-9,_,$,#.
-- names are case-sensitive, sensitivity can be controlled by ""
-- there are some reserved words that can't be used:SELECT, FROM etc...

-- names should have plural form
-- if space, it need underscore
-- column names should include alias for related table
-- column names should be singular
-- prymary key columns should end with ***_ID
-- names should be consistent

-- CREATE TALBE SCHEMA.TABLE_NAME
-- SCHEMA IS OPTIONAL, DEFAULT IS CURRENT SCHEMA
-- if NULL is not stated, by default null is possible
-- default value is returned is when we insert null

 -- Creating Tables

CREATE TABLE my_employees
(employee_id   NUMBER(3)  NOT NULL,
first_name    VARCHAR2(50) DEFAULT 'No Name',
last_name     VARCHAR2(50),
hire_date     DATE DEFAULT sysdate NOT NULL);

SELECT * FROM my_employees;

-- DROP deleting table entirely
-- Delete deleting row by row, can use WHERE
-- Truncate delete rows

CREATE TABLE random_1
(employee_id   NUMBER(3)  NOT NULL,
first_name    VARCHAR2(50)  DEFAULT 'No Name',
last_name     VARCHAR2(50),
hire_date     DATE DEFAULT sysdate NOT NULL);

SELECT * FROM random_1;
DROP Table random_1;

-- CTAS statements -  create table as SELECT keyword

CREATE TABLE employees_copy AS 
SELECT * FROM employees;

SELECT * FROM  employees_copy;

-- Column names and data types
CREATE TABLE Only_cols AS
SELECT * FROM employees WHERE 1=2;

SELECT * FROM only_cols;

-- Restricting rows
CREATE TABLE employees_copy2 AS 
SELECT * FROM employees WHERE job_id = 'IT_PROG';

SELECT * FROM employees_copy2;

-- choosing specifit columns
CREATE TABLE employees_copy3 AS 
SELECT first_name, last_name, salary FROM employees;

SELECT * FROM employees_copy3;

-- Alias-ის სახელის შეცვალც მოსულა
CREATE TABLE employees_copy4 AS 
SELECT first_name, last_name l_name, salary FROM employees;

SELECT * FROM employees_copy4;


CREATE TABLE employees_copy5 (name, surname) AS  
SELECT first_name, last_name l_name, salary FROM employees;


CREATE TABLE employees_copy5 (name, surname, annual_salary) AS 
SELECT first_name, last_name l_name, salary*12 FROM employees;


SELECT * FROM employees_copy5;

   -- Altering Tables

-- add columns, modify data types, drop columns, renamae table/column

-- Adding columns
ALTER TABLE employees_copy ADD ssn varchar2(11);
SELECT * FROM employees_copy;

-- When manipulated multiple columns we need to use ()

-- Adding multple columns
ALTER TABLE employees_copy
ADD (fax_number VARCHAR2(11), 
    birth_date DATE, 
    password VARCHAR2(10) DEFAULT 'abc1234'); 
    
SELECT * FROM  employees_copy;

-- Modifying columns:data type, default value and nullability

-- Single Column
ALTER TABLE employees_copy MODIFY password VARCHAR2(50);


-- Multiple Columns
ALTER TABLE employees_copy MODIFY 
      (fax_number VARCHAR2(11) DEFAULT '-',
       password VARCHAR2(10));
-- You can't remove default values completely

-- Default values are used when we adding new columns, replacing NULLs with itself
SELECT * FROM  employees_copy;


-- DROP statements
   
ALTER TABLE employees_copy DROP COLUMN ssn; -- drop single column
ALTER TABLE employees_copy DROP (fax_number, password); -- drop multiple columns
ALTER TABLE employees_copy DROP (birth_date); 
SELECT * FROM employees_copy;

-- Marking columns Unused (Instead of Droping)
 -- Colum becomse invisible and inaccessible

ALTER TABLE employees_copy SET UNUSED (first_name, phone_number, salary);
SELECT * FROM employees_copy;
   -- now can be added new columns with those names (first_name, ....)
   
   -- ინფორმაციას ინახავს Unused Column-ების შესახებ
   SELECT * FROM USER_UNUSED_COL_TABS;
   
    -- Don't stop operations while making unused
ALTER TABLE employees_copy SET UNUSED COLUMN last_name ONLINE;

ALTER TABLE employees_copy DROP UNUSED COLUMNS;
  
  -- Read Only Tables

-- Only read, but not modify
  -- Read Only, Read Write
  
  
  CREATE TABLE emp_temp AS SELECT * FROM employees;
  SELECT * FROM emp_temp;

  ALTER TABLE emp_temp READ ONLY;
  DELETE emp_temp; -- not allowed, beacuse it is read only
  ALTER TABLE emp_temp ADD gender VARCHAR2(1); 
  ALTER TABLE emp_temp DROP (gender);
  DROP TABLE emp_temp; 
  SELECT * FROM emp_temp;
  ALTER TABLE emp_temp READ WRITE; -- make modifications again
     
    
  -- DROP Table
     -- DROPED table goes to recycle been
        

SELECT * FROM employees_copy4;

DROP TABLE employees_copy5;

DROP TABLE employees_copy4;

     -- Droping multiple tables is not possible
DROP TABLE employees_copy3, employees_copy4;
     -- Nor with this way
DROP employees_copy3, employees_copy4;
     -- Nor with this way
DROP TABLES employees_copy3, employees_copy4;

SELECT * FROM employees_copy3;

DROP TABLE employees_copy3;
     -- Table is restored -
FLASHBACK TABLE employees_copy3 TO BEFORE DROP;
          -- recover table previous state
          
DROP TABLE employees_copy3 PURGE;

     
     -- Truncate Tables

SELECT * FROM employees_copy;
DELETE FROM employees_copy; -- Row by Row it is process consuming

 -- row by row example of DELETE
create table emp2 as Select * FROM employees;
SELECT * FROM emp2;
delete FROM emp2 WHERE manager_id>103;
SELECT * FROM emp2;
       -- Control+Z მოსულა Delete-ზე, Truncate        
          -- Auto-Commit-ის გამო, DDL Statment-ია Truncate
          
          
 -- Truncate deletes all rows in one step 
    -- it is part of DDL, so each statement is auto-commited
TRUNCATE TABLE employees_copy;
SELECT * FROM employees_copy;
DROP TABLE employees_copy; 
  
 
 -- Working with small data Delete is better to use

 -- Creating Large Table
CREATE TABLE employees_performance_test AS 
SELECT e1.first_name, e1.last_name, e1.department_id, e1.salary 
       FROM employees e1 CROSS JOIN employees e2 CROSS JOIN employees e3; 

-- more than 1 million rows
SELECT COUNT(*) FROM employees_performance_test;

DELETE FROM employees_performance_test;

TRUNCATE TABLE employees_performance_test; 

DROP TABLE employees_performance_test; -- finally just droping table

  -- can drop that is crated under our schema, or someone need to give DROP ANY TABLE privilage
  
  
  -- Comment Statement
     -- For Huge Projects 
     -- Add explanation to table or column  
  
CREATE TABLE employees_copy AS SELECT * FROM employees; 


COMMENT ON COLUMN employees_copy.job_id IS 'Stores job title abbreviations';

COMMENT ON TABLE employees_copy IS 'This is a copy of the employees table';

COMMENT ON COLUMN employees_copy.hire_date IS 'The date when the employee started this job';
  -- deleting comment with '' 
  -- adding new column is same as replacig old with new one
COMMENT ON COLUMN employees_copy.hire_date IS '';

-- user_tab_comments, user_col_comments
-- they are data dictionary views created on background by SQL
SELECT * FROM user_tab_comments;
SELECT * FROM user_col_comments;

   -- comment '' is viewed as NULL


SELECT * FROM user_tab_comments WHERE table_name = 'EMPLOYEES_COPY';

SELECT * FROM user_col_comments WHERE table_name = 'EMPLOYEES_COPY';     


   -- RENAME
      

-- renaming column
ALTER TABLE employees_copy RENAME COLUMN hire_date TO start_date;
 
-- renaming table
RENAME employees_copy TO employees_backup;
  
 --  should care about other dependent objects based on name
SELECT * FROM employees_copy;
SELECT * FROM employees_backup;
 
-- Second syntax of renaming
ALTER TABLE employees_backup RENAME TO employees_copy;
SELECT * FROM employees_copy;

  
-- what a relieve
SELECT * FROM games;
alter table games rename column "GAME NAME" to Game_name;
alter table games rename column "GAME GENRE" to Game_Genre;
SELECT * FROM games;




