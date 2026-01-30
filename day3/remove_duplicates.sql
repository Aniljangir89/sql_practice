-- Active: 1769534664761@@127.0.0.1@3306@day3

show DATABASEs;

create DATABASE day3;

use day3;
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);

INSERT INTO Employees (EmployeeID, Name, Department, Salary) VALUES
(1, 'Alice', 'HR', 5000.00),
(2, 'Bob', 'IT', 6000.00),
(3, 'Alice', 'HR', 5000.00),   -- duplicate of Alice
(4, 'Charlie', 'Finance', 7000.00),
(5, 'Bob', 'IT', 6000.00);     -- duplicate of Bob




with duplicate_cte as(
      select *,
      row_number() over (partition by Name order by Salary) as row_num
      from Employees
    )
    delete from Employees
    where EmployeeID in (
      select EmployeeID from duplicate_cte where row_num>1
    );

select * from Employees;


SELECT * from 
`Employees` 
order by Salary
desc limit 3;

-- we can also do by usign ranking function 


SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num
    FROM Employees
) t
WHERE row_num <= 3;

-------------------------------------merge stmt
-- Target table (main data)
 
drop table `Employees`;
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary INT
);

-- Insert initial data
INSERT INTO employees VALUES
(1, 'Alice', 'HR', 50000),
(2, 'Bob', 'IT', 60000),
(3, 'Charlie', 'Finance', 55000);

-- Staging table (new data to merge)
CREATE TABLE employees_stage (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary INT
);

-- Insert new/updated data
INSERT INTO employees_stage VALUES
(2, 'Bob', 'IT', 65000),       -- Existing employee, salary updated
(3, 'Charlie', 'Finance', 55000), -- Same data, no change
(4, 'David', 'HR', 48000);     -- New employee

insert into employees(emp_id,name,department,salary)
select emp_id,name,department,salary
from employees_stage
on DUPLICATE key UPDATE
name = VALUES(name),
department = values(department),
salary = values(salary);

select * from employees;


CREATE TABLE sales (
    emp   VARCHAR(10),
    month VARCHAR(10),
    amount INT
);


INSERT INTO sales (emp, month, amount) VALUES
('A', 'Jan', 100),
('A', 'Feb', 150),
('B', 'Jan', 200),
('B', 'Feb', 250);


--- row - > cols

create table pivoted_sales as select emp, sum(case when month  = 'Jan' then amount end) as Jan,
sum(case when month = 'Feb' then amount end ) as Feb 
from sales
group by emp;

select * from sales;


--- col- > rows
SELECT emp, 'Jan' AS month, Jan AS amount FROM pivoted_sales
UNION ALL
SELECT emp, 'Feb', Feb FROM pivoted_sales;









------------------json handling

create table customers (
    id int PRIMARY key,
    details json 
);

INSERT into customers VALUES
(1,'{"name":"alice","city":"bik"}'),
(2,'{"name":"ram","city":"jai"}');

select id,JSON_EXTRACT(details,'$.name')as name, 
JSON_EXTRACT(details,'$.city') as city
from customers;

UPDATE customers set 
details = json_set(details,'$.city','delhi')
where id = 1;


----------------------fact table-----------------

-- Dimension: Customer

CREATE TABLE dim_customer (
    cust_id INT PRIMARY KEY,
    cust_name VARCHAR(50),
    city VARCHAR(50)
);

-- Dimension: Product


CREATE TABLE dim_product (
    prod_id INT PRIMARY KEY,
    prod_name VARCHAR(50),
    category VARCHAR(50)
);


-- Fact: Sales


CREATE TABLE fact_sales (
    sale_id INT PRIMARY KEY,
    cust_id INT,
    prod_id INT,
    sale_date DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (cust_id) REFERENCES dim_customer(cust_id),
    FOREIGN KEY (prod_id) REFERENCES dim_product(prod_id)
);

----------------------------------cleaning---------------


use day3;

show tables;

select * from sales;

insert into sales values('C',NULL,100);

update sales
set month = "NA" 
where month is NULL;


---------------------------------------------incremental pipeline----------


-- Step 1: Create Source and Target Tables

CREATE TABLE employees_source (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE employees_target (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    last_updated TIMESTAMP
);
-- Step 2: Insert Initial Data into Source
INSERT INTO employees_source (emp_id, name, department, salary) VALUES
(1, 'Alice', 'HR', 5000),
(2, 'Bob', 'IT', 6000),
(3, 'Charlie', 'Finance', 7000);
-- 🔹 Step 3: First Load (Full Load)
-- STEP3 :FULL LOAD
INSERT INTO employees_target
SELECT * FROM employees_source;
-- Now both tables are identical.
-- Step 4: Simulate Changes in Source
-- Add a new employee and update an existing one:
-- New employee
INSERT INTO employees_source (emp_id, name, department, salary) 
VALUES (4, 'David', 'IT', 6500);

CREATE TABLE employees_source (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
insert into employees_target (select e1.emp_id,e1.name,e1.department,e1.salary,e1.last_updated
FROM employees_source e1
left join employees_target e2 on e1.emp_id = e2.emp_id
where e2.emp_id is NULL
);

SELECT * from employees_target;


----HOME ---- what if we update the table














---------------------------------------stored procedure_-----------------


create Procedure getem2(in deptname varchar(50))
begin 
  select emp_id,name,salary
  from employees_source
  where department = deptname;
end

call getemp1('HR');








---------LAG,LEAD-----------    