CREATE TABLE customer (
    cust_id INT PRIMARY KEY,
    cust_name VARCHAR(50),
    city VARCHAR(50),
    start_date DATE,
    end_date DATE
);


--SCD Type 1 (Overwrite):

UPDATE customer
SET city = 'Mumbai'
WHERE cust_id = 101;


--Old city is lost; only latest value remains.
--SCD Type 2 (Add Row with History):
-- End old record
UPDATE customer
SET end_date = CURDATE()
WHERE cust_id = 101 AND end_date IS NULL;

-- Insert new record

INSERT INTO customer (cust_id, cust_name, city, start_date, end_date)
VALUES (101, 'Rahul', 'Mumbai', CURDATE(), NULL);

--SCD Type 3 (Add Column for Previous Value):



ALTER TABLE customer ADD COLUMN prev_city VARCHAR(50);

UPDATE customer
SET prev_city = city,
    city = 'Mumbai'
WHERE cust_id = 101;



 --Stores both current and previous city in the same row.
