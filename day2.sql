show DATABASEs;

create DATABASE day2;

use day2;
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);



INSERT INTO employees VALUES
(1, 'Alice', 'Johnson', 'alice.johnson@example.com'),
(2, 'Bob',   'Smith',   'bob.smith@example.com'),
(3, 'Charlie','Brown',  'charlie.brown@example.com'),
(4, 'Diana', 'Lee',     'diana.lee@example.com');

SELECT * FROM employees;

-- string fuctio
-- concat() : used to combine two or more strings into one string
--subtr(): used to extract a substring from a string
--  subtring(str,start,length) str: original string, start: starting position, length: number of characters to extract
--date(): used to extract the date part from a datetime value
-- now(): returns the current date and time

select concat(first_name,' ',last_name) as full_name from employees;

select SUBSTRING(email,1,5) as email_prefix from employees;

-----------------------------------------------------------------------------------
create table sales(
    id int PRIMARY key,
    sale_date date,
    amount decimal(10,2)
)

insert into sales values
(1,'2023-01-15',150.75),
(2,'2023-02-20',200.00),
(3,'2023-03-10',300.50),
(4,'2023-04-05',400.25),
(5,'2023-05-18',500.00),
(6,'2023-06-22',600.75);


select * from sales;

-- find the month wise sales
-- using substring function to extract month from sale_date
select SUBSTRING(sale_date,6,2) as sale_month, sum(amount) as total_sales
from sales
group by sale_month
order by sale_month;

-- we can also write it as 
insert into sales VALUES
(7,'2024-01-12',250.00),
(8,'2024-02-14',350.00),
(9,'2024-03-16',450.00);
select year(sale_date) as sales_year,sum(amount) as total_sales
from sales
group by sales_year
ORDER BY sales_year;

-- for cleaner code, mysql also has DATE_FORMAT(sales_date,'%Y-%m') function to extract year and month together
select DATE_FORMAT(sale_date,'%Y-%m') as sale_month, sum(amount) as total_sales
from sales
group by sale_month
order by sale_month;

select concat('hello',' ','world') as greetng;


--- REGEXP
-- short for regular expression in as operation used for advanced pattern matching in strings,it allows you to search,filter,and validate text data based on specific patterns

use day2;
select * from sales
where sale_date REGEXP '^2024-';

show tables;
---find the emails which ends with .com
select email from employees
where email REGEXP '\\.com';



CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    order_date DATE,
    delivery_date DATE
);

INSERT INTO orders (order_id, customer_name, order_date, delivery_date) VALUES
(1, 'Alice', '2026-01-10', '2026-01-15'),
(2, 'Bob',   '2026-01-12', '2026-01-20'),
(3, 'Charlie','2026-01-15', '2026-01-25'),
(4, 'Diana', '2026-01-18', '2026-01-28');

--- Date functions
-- DATE_ADD(): used to add a specified time interval to a date

  -- date_add(order_date, interval 7 day) adds 7 days to order_date


-- DATE_SUB(): used to subtract a specified time interval from a date
   
-- DATEDIFF(): used to calculate the difference between two dates in days



-- Q add 7 days to each order date to caluculate expected delivery date

use day2;
select order_id,Date_add(order_date, interval 45 day) as expected_delivery_date
from orders;


select order_id,customer_name, datediff(delivery_date,order_date) as delivery_duration_days
from orders;

select order_id, customer_name, EXTRACT(DAY from order_date) as order_month 
from orders;


CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    price DECIMAL(10,2),
    discount DECIMAL(5,2)
);
------round(),ceil(),floor()-----------
INSERT INTO products (product_id, product_name, price, discount) VALUES
(1, 'Laptop', 999.75, 10.5),
(2, 'Phone', 499.40, 5.2),
(3, 'Tablet', 299.99, 0.0),
(4, 'Headphones', 89.65, 2.8);


select product_id,product_name,price,round(price) as rounded_price,
round(price,1) as rounded_price_1_decimal
from products;

select product_id,product_name,price,CEIL(price) as ceil_price
from products;

select product_id,product_name,price,floor(price) as floor_price
from products;


---- case------

select product_id,product_name,price,
CASE 
    when discount = 0 then "not discount"
    WHEN discount > 0 and discount < 5 THEN "low  discount" 
    WHEN discount >=5 and discount <10 THEN "medium discount"
    ELSE "high discount"

END as discount_level
from products;


-----------CTE-----

show tables;
use day2;
drop table orders;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    order_date DATE,
    amount DECIMAL(10,2)
);

INSERT INTO orders (order_id, customer_name, order_date, amount) VALUES
(1, 'Alice', '2026-01-10', 250.00),
(2, 'Bob',   '2026-01-12', 450.00),
(3, 'Charlie','2026-01-15', 300.00),
(4, 'Diana', '2026-01-18', 150.00),
(5, 'Alice', '2026-01-20', 500.00);

select * from orders;
-- suppose we want to find each customers total spending and then filter only those who spend more then 400
with total_spending as (
    select customer_name,sum(amount) as total_spent  
    from orders
    group by customer_name 
)
select customer_name , total_spent
from total_spending
WHERE total_spent>400;

-- we can also write it as 
select customer_name,sum(amount) as total_spent
from orders
group by customer_name
having total_spent>400;


DESCRIBE orders;
-----------subqueries-----------------------------------------------------------

use day2;

show tables;

DESCRIBE employees

drop table employees;


create table employees(
    empid INT PRIMARY KEY,
    name VARCHAR(30),
    salary INT,
    department VARCHAR(30)
)

insert into employees(empid,name,salary,department) values(100,'ram',20000,'sales'),
(101,'shyam',50000,'it'),
(102,'riya',30000,'it');

select * from employees;

create table department(
    depid INT primary key,
    deparment VARCHAR(40)
);
alter table department RENAME COLUMN
deparment to department;
insert into department(depid,deparment) VALUES
(1,'it'),(2,'accound'),(3,'support');
insert into department(depid,department)VALUES
(4,'account');
SELECT * from department

select * 
from employees
where department = (
    select department from department where depid =1
);

show tables;
drop table orders;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50)
);

INSERT INTO customers VALUES
(1, 'Alice', 'Delhi'),
(2, 'Bob', 'Mumbai'),
(3, 'Charlie', 'Delhi'),
(4, 'Diana', 'Chennai');


CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    amount DECIMAL(10,2)
);

INSERT INTO orders VALUES
(101, 1, 250.00),
(102, 2, 450.00),
(103, 2, 300.00),
(104, 3, 150.00);

--- find customer who spent more than the averge order amuont

select customer_name
from customers
where customer_id  IN (SELECT customer_id  from orders
where amount>(select avg(amount)from orders));



------------JOINs----------------------------------------------------
use day2;
---find the total spent by customer
select c.customer_name,(select sum(amount) from orders o 
where o.customer_id = c.customer_id) as total_spent
from customers c;




drop table customers, orders;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);
INSERT INTO customers VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'Diana');
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product VARCHAR(50)
);
INSERT INTO orders VALUES
(101, 1, 'Laptop'),
(102, 2, 'Phone'),
(103, 2, 'Tablet'),
(104, 5, 'Headphones'); -- Note: customer_id=5 does not exist in customers



select c.customer_name ,o.product
from customers c
left join orders o ON c.customer_id = o.customer_id
where o.product = 'Phone';


select c.customer_name,o.product
from customers c
cross join orders o ;


-------------------------

use day2;
CREATE TABLE salesman (
    salesman_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    commission DECIMAL(4,2)
);


INSERT INTO salesman VALUES
(5001, 'James Hoog', 'New York', 0.15),
(5002, 'Nail Knite', 'Paris', 0.13),
(5005, 'Pit Alex', 'London', 0.11),
(5006, 'Mc Lyon', 'Paris', 0.14),
(5003, 'Lauson Hen', NULL, 0.12),
(5007, 'Paul Adam', 'Rome', 0.13);

CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50),
    grade INT,
    salesman_id INT
);

INSERT INTO customer VALUES
(3002, 'Nick Rimando', 'New York', 100, 5001),
(3005, 'Graham Zusi', 'California', 200, 5002),
(3001, 'Brad Guzan', 'London', NULL, 5005),
(3004, 'Fabian Johns', 'Paris', 300, 5006),
(3007, 'Brad Davis', 'New York', 200, 5001),
(3009, 'Geoff Cameron', 'Berlin', 100, 5003),
(3008, 'Julian Green', 'London', 300, 5002),
(3003, 'Jozy Altidor', 'Moscow', 200, 5007);
drop table orders;
CREATE TABLE orders (
    order_no INT PRIMARY KEY,
    purch_amt DECIMAL(10,2),
    order_date DATE,
    customer_id INT,
    salesman_id INT
);

INSERT INTO orders VALUES
(70001, 150.50, '2016-10-05', 3005, 5002),
(70009, 270.65, '2016-09-10', 3001, 5005),
(70002, 65.26,  '2016-10-05', 3002, 5001),
(70004, 110.50, '2016-08-17', 3009, 5003),
(70007, 948.50, '2016-09-10', 3005, 5002),
(70005, 2400.60,'2016-07-27', 3007, 5001),
(70008, 5760.00,'2016-09-10', 3002, 5001),
(70010, 1983.43,'2016-10-10', 3004, 5006),
(70003, 2480.40,'2016-10-10', 3009, 5003),
(70012, 250.45, '2016-06-27', 3008, 5002),
(70011, 75.29,  '2016-08-17', 3003, 5007);


--- order placed by salesman paul

---display all the order which values are greater than the avg order value for 10thoct2016

select * from orders
where purch_amt > (SELECT avg(purch_amt) 
from orders where order_date = '2016-10-10'
);


--find all orders attributed to salesman in paris

select o.order_no,s.name,s.city 
from orders o 
join salesman s ON o.salesman_id = s.salesman_id
where s.city = 'Paris';

-- extract the data from order table for the salesman who earned the max commision
use day2;
select o.order_no,o.purch_amt,o.order_date,o.salesman_id
from orders o 
join salesman s ON o.salesman_id = s.salesman_id
where s.commission = (select max(s1.commission) from salesman s1);

