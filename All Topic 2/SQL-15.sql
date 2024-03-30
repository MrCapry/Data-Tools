﻿
  -- Data Dictionary Views
  -- Can't use DML or any other on such Views  
  -- Read Only
   

  
SELECT * FROM user_objects
WHERE object_type = 'TABLE';

SELECT * FROM user_tables; 
  
SELECT * FROM user_views;   
  

SELECT  * FROM user_tab_columns;



   -- All Dic. Views
SELECT * FROM dictionary;

SELECT * FROM dict;

SELECT * FROM dict WHERE table_name = 'USER_CONSTRAINTS';

SELECT * FROM dict WHERE upper(comments) LIKE '%CONSTRAINT%';
  


  -- information about objects
SELECT * FROM user_objects
WHERE object_type = 'TABLE';
  
 -- also exists in recycle bin
SELECT * FROM user_catalog; 
SELECT * FROM cat; 
 
 -- we own or we have access
SELECT * FROM all_objects;


SELECT * FROM dba_objects;

  

SELECT * FROM user_tables;

SELECT * FROM user_views; 

SELECT * FROM tabs;-- same as table
 
SELECT * FROM all_tables;
 
SELECT * FROM dba_tables;
  

-- Information about columns
SELECT  * FROM user_tab_columns;
SELECT  * FROM cols; 



SELECT * FROM user_tab_columns WHERE table_name = 'DEPARTMENTS';
 
SELECT * FROM all_tab_columns WHERE table_name = 'DEPARTMENTS';
  
  -- Important Columns are: Data type, Data Length, Nullable, Data Default, Nul_NULLs,Avg_Col_Len,Num_Distinct
  
 -- User Contraints  


SELECT * FROM user_constraints;
 
SELECT * FROM all_constraints;
 
SELECT * FROM dba_constraints;
  
  -- Contraint Type - C,P,U ...etc
  
  
-- User Cons Columns

 -- Constraints on Columns
SELECT * FROM user_cons_columns;
SELECT * FROM user_cons_columns WHERE table_name = 'EMPLOYEES';
 
-- Join
SELECT * FROM user_cons_columns a JOIN user_constraints b
ON(a.table_name = b.table_name AND a.constraint_name = b.constraint_name)
WHERE a.table_name = 'EMPLOYEES';
 

SELECT b.constraint_type, a.* FROM user_cons_columns a JOIN user_constraints b
ON(a.table_name = b.table_name AND a.constraint_name = b.constraint_name)
WHERE a.table_name = 'EMPLOYEES';
 
SELECT b.constraint_type, a.*, b.r_constraint_name FROM user_cons_columns a JOIN user_constraints b
ON(a.table_name = b.table_name AND a.constraint_name = b.constraint_name)
WHERE a.table_name = 'EMPLOYEES';
 
SELECT b.constraint_type, a.*, b.r_constraint_name FROM user_cons_columns a JOIN user_constraints b
ON(a.table_name = b.table_name AND a.constraint_name = b.constraint_name)
ORDER BY a.table_name, a.constraint_name;
 
SELECT * FROM all_cons_columns;
SELECT * FROM dba_cons_columns;


  -- Constraints on Views
  
SELECT * FROM user_views;


SELECT * FROM user_tab_comments;
SELECT * FROM user_col_comments;

SELECT * FROM user_tab_comments WHERE upper(comments) LIKE '%EMPLOYEE%';
 
SELECT * FROM user_tab_comments WHERE upper(comments) LIKE '%SALARY%';
 
SELECT * FROM jobs;

SELECT * FROM user_col_comments WHERE upper(comments) LIKE '%SALARY%';  



SELECT * FROM USER_UNUSED_COL_TABS;



  
  
  