create DATABASE day4;

use day4;

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


select * from Employees;

create index idx_lastname
on Employees(name);

show index from employees;

select * from employees where name ='Alice';

--- if we want to drop the index




ALTER table employees drop index idx_lastname;

show index from employees;


----------partitions COMMENT-------------


 
--Example: Partition employees by department_id using RANGE partitioning.


CREATE TABLE employees_partitioned (
    emp_id INT NOT NULL,
    name VARCHAR(50),
    department_id INT NOT NULL,
    salary DECIMAL(10,2),
    PRIMARY KEY(emp_id, department_id)
)
PARTITION BY RANGE (department_id) (
    PARTITION p0 VALUES LESS THAN (10),
    PARTITION p1 VALUES LESS THAN (20),
    PARTITION p2 VALUES LESS THAN (30),
    PARTITION p3 VALUES LESS THAN MAXVALUE
);

--Step 2: Insert Sample Data

INSERT INTO employees_partitioned VALUES
(1, 'Alice', 5, 5000),
(2, 'Bob', 12, 6000),
(3, 'Charlie', 18, 7000),
(4, 'David', 25, 6500),
(5, 'Eva', 35, 7200);


select * from employees_partitioned 
where department_id = 5         ;