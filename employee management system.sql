-- 1. CREATE A DATABASE AND IMPORT DATA: --

-- creating database --
CREATE DATABASE IF NOT EXISTS employee;

use employee;             -- using the database to stored the tables in it --

-- creating tables --
CREATE TABLE IF NOT EXISTS Data_science_team(
EMP_ID int primary key,
FIRST_NAME varchar(50),               -- varchar here is storage capacity of the variable in bytes --
LAST_NAME varchar(50),
GENDER varchar(5),
ROLE_ varchar(50),
DEPT varchar(50),
EXP INT,                               -- defining the data type --
COUNTRY varchar(50),
CONTINENT varchar(50)
);

-- transfering or loading the data from excel csv file in our ceated table --
LOAD DATA INFILE"C:\\Users\\yashp\\OneDrive\\Desktop\\SQL Project 1\\Data_science_team.csv"INTO TABLE data_science_team;

/* NOTE :- when excuting the statement "load data file" above if it shows that "mysql server is running with the -- secure-file-priv option so it cannot excute statement" so you have to solve it using youtube,chrome etc only on trusted websites or channels because it is not an error in the code */ 

-- you can cheak the tables in the database --
SHOW TABLEs;

CREATE TABLE IF NOT EXISTS emp_record_table(
EMP_ID int primary key,
FIRST_NAME varchar(50),
LAST_NAME varchar(50),
GENDER varchar(5),
ROLE_ varchar(50),
DEPT varchar(50),
EXP int,
COUNTRY varchar(50),
CONTINENT varchar(50),
SALARY varchar(50),
EMP_RATING varchar(50),
MANAGER_ID varchar(50),
PROJ_ID varchar(100)
);

LOAD DATA INFILE"C:\\Users\\yashp\\OneDrive\\Desktop\\SQL Project 1\\emp_record_table.csv"INTO TABLE emp_record_table;

CREATE TABLE IF NOT EXISTS Proj_table(
PROJECT_ID int primary key,
PROJ_NAME varchar(100),
DOMAIN varchar(100),
START_DATE varchar(50),
CLOSURE_DATE varchar(50),
DEV_QTR varchar(50),
STATUS_ varchar(50)
);

LOAD DATA INFILE"C:\\Users\\yashp\\OneDrive\\Desktop\\SQL Project 1\\Proj_table.csv"INTO TABLE Proj_table;


-- 3. FETCHING EMPLOYEE DETAILS: --

-- selecting the data which we want to display in line 1 --

SELECT EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT
FROM emp_record_table;                        -- table from where we will fetch data --

-- 4. fetchING employee rating --

-- LESS THAN 2 --
SELECT EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT,EMP_RATING       
FROM emp_record_table
WHERE EMP_RATING < 2;                         -- using "where" to put a condition for the data which want accordingly --

-- GREATER THAN 4 --
SELECT EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT,EMP_RATING
FROM emp_record_table
WHERE EMP_RATING > 4;

-- BETWEEN 2 AND 4 --
SELECT EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT,EMP_RATING
FROM emp_record_table
WHERE EMP_RATING BETWEEN 2 AND 4;

-- 5. concatenating(JOINING TWO COLOUMS) first and last name of employee --
                 --  where department is finance --
             
SELECT CONCAT(FIRST_NAME,'',LAST_NAME) AS NAME
FROM emp_record_table                          
WHERE DEPT = 'Finance'

-- 6. employee who is reporting to someone under whom he/she is  --

SELECT EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT
FROM emp_record_table
WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID FROM emp_record_table WHERE MANAGER_ID IS NOT NULL);

-- 7. using "union" to combine the two different data --

-- where department is healthcare --
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT
FROM emp_record_table
WHERE DEPT = 'Healthcare'
UNION
-- where department is finance --
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT
FROM emp_record_table
WHERE DEPT = 'Finance';

-- 8. to display the data employee rating in descending order where all departments should be separated from each other--

-- using over() function --
-- it will divide the department and show it by order of max employee rating --

SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE_, DEPT, EMP_RATING,MAX(EMP_RATING) OVER(PARTITION BY DEPT) AS MAX_RATING
FROM emp_record_table;

-- note :- over is used to put on more conditions in a proper manner to  arreange the data

-- 9. showing minimum and maximum salary of each role of employee  --

-- max() and min() here to show maximun and minimum salary --
SELECT ROLE_, MIN(SALARY) AS MIN_SALARY, MAX(SALARY) AS MAX_SALARY
FROM emp_record_table
GROUP BY ROLE_;

-- here max() and min() are built in functions --

-- 10. ranking the employee according to there experience in descending order  --

-- rank() to rank them --
SELECT EMP_ID, FIRST_NAME, LAST_NAME, EXP,RANK() OVER (ORDER BY EXP DESC) AS EXP_RANK
FROM emp_record_table;

-- 11. create an view and show employee details whose salary are above 6000  --

-- creating a view --
CREATE VIEW HIGH_SALARY_COUNTRIES AS
SELECT EMP_ID,FIRST_NAME,LAST_NAME,COUNTRY,SALARY
FROM emp_record_table
WHERE SALARY > 6000 ;          -- condition --

-- 12. show employee whose experience is greater than 10 using nested condtions  --

-- nested condition:- condition inside a condition -- 
SELECT EMP_ID, FIRST_NAME, LAST_NAME, EXP
FROM emp_record_table
WHERE EXP > (SELECT MAX(EXP) FROM emp_record_table WHERE EXP <= 10);

-- 13. create procedure to display the employee details whose experience are above 3 --

-- delimiter here works with procedure creation --
DELIMITER //
CREATE PROCEDURE Get_Exp_Emp()       -- similar to function in any other computer language --
BEGIN                                -- code block starts --  
    SELECT EMP_ID, FIRST_NAME, LAST_NAME, EXP
    FROM emp_record_table
    WHERE EXP > 3;
END //                               -- code block ends --
DELIMITER ;

-- 14. create a function to check the employee job profile according to  --
/*   The standard being:
For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST', */

DELIMITER //
CREATE FUNCTION MJob_Prof(exp INT) RETURNS VARCHAR(50)
BEGIN
	DECLARE JOB_PROF VARCHAR(50);          -- declaring the variable --
    
    -- conditions --
    IF EXP <= 2 THEN
        SET JOB_PROF = 'JUNIOR DATA SCIENTIST';
    ELSEIF EXP <= 5 THEN
        SET JOB_PROF = 'ASSOCIATE DATA SCIENTIST';
    ELSEIF EXP <= 10 THEN
        SET JOB_PROF = 'SENIOR DATA SCIENTIST';
    ELSEIF EXP <= 12 THEN
        SET JOB_PROF = 'LEAD DATA SCIENTIST';
    ELSE
        SET JOB_PROF = 'MANAGER';
    END IF;
    RETURN JOB_PROF;
END //
DELIMITER ;

SELECT EMP_ID,FIRST_NAME,LAST_NAME,EXP,MJob_Prof(exp) AS MJOB_PROFILE,
	CASE
        WHEN MJob_Prof(EXP) = JOB_PROF         -- using when for condition like if --
        THEN "THE PROFILE MATCHES THE JOB STATUS"
        
        ELSE "THE PROFILE DOES NOT MATCHES THE JOB STATUS"
	END AS MATCH_STATUS
FROM data_science_team;


-- 15. Create an index for employee with FIRST_NAME 'Eric' --

CREATE INDEX IND_NAME ON emp_record_table (FIRST_NAME) WHERE FIRST_NAME = "ERIC";

-- 16. Calculate bonus for all employees --
-- using formula 0.05*

SELECT EMP_ID, FIRST_NAME, LAST_NAME, SALARY, EMP_RATING,5/100 * SALARY * EMP_RATING AS BONUS_of_employees
FROM emp_record_table;

-- 17. Average salary distribution based on continent and country --

SELECT CONTINENT, COUNTRY, AVG(SALARY) AS AVG_SALARY
FROM emp_record_table
GROUP BY CONTINENT, COUNTRY;   -- group by statement here will merge the all same country and continent --


                -- HOPE SO YOU FOUND IT HELPFULL :) --
                
                
                