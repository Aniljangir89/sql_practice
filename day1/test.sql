CREATE DATABASE sample;

USE sample;

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    position VARCHAR(100),
    salary DECIMAL(10, 2)
);

INSERT INTO employees (id, name, position, salary) VALUES
(1, 'Alice Johnson', 'Manager', 75000.00),
(2, 'Bob Smith', 'Developer', 60000.00),
(3, 'Charlie Brown', 'Designer', 55000.00);

SELECT * FROM employees;

SHOW DATABASES;

-- UPDATE: used to modify existing records in a table
UPDATE employees 
SET salary = salary * 2
WHERE position = 'Developer';

SELECT * FROM employees;

-- ALTER: used to modify the structure of a table
-- Only for changes to table design, not the data itself

SHOW TABLES;

ALTER TABLE employees
ADD COLUMN email VARCHAR(300) DEFAULT 'not provided';

SELECT * FROM employees;

ALTER TABLE employees
DROP COLUMN position;

SELECT * FROM employees;

ALTER TABLE employees
MODIFY COLUMN name VARCHAR(200);

-- DELETE: remove specific records from a table based on a condition
-- Use WHERE clause to specify which records to delete

DELETE FROM employees
WHERE salary < 60000;

SELECT * FROM employees;

-- To delete all records from a table without deleting the table itself
DELETE FROM employees;

SELECT * FROM employees;

DESCRIBE employees;

INSERT INTO employees (id, name, salary, email) VALUES
(1, 'Alice Johnson', 75000.00, 'alice.johnson@example.com'),
(2, 'Bob Smith', 60000.00, 'bob.smith@example.com'),
(3, 'Charlie Brown', 55000.00, 'charlie.brown@example.com'),
(4, 'Diana Prince', 80000.00, 'diana.prince@example.com');
SELECT * FROM employees;


TRUNCATE Table employees;
SELECT * FROM employees;

-- | Feature              | DELETE | TRUNCATE       |
-- | -------------------- | ------ | -------------- |
-- | WHERE clause         | ✅ Yes  | ❌ No           |
-- | Speed                | Slower | 🚀 Very fast   |
-- | Rollback             | ✅ Yes  | ❌ No (usually) |
-- | Triggers             | ✅ Fire | ❌ Don’t fire   |
-- | Auto-increment reset | ❌ No   | ✅ Yes          |
-- | Table structure      | Kept   | Kept           |





