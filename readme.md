

## Date function

1. Date_add :
* used to add a specified time interval to a date
  - date_add(order_date, interval 7 day) adds 7 days to order_date

2. Date_diff:
* return the difference in days between two dates.
* date_diff(date1,date2)

3. extract
* pullout specific part of date(year,month,day,etc);
* extract(unit from date)
* unit : the part of the date to extract
* date:the date or datetime value


## Numerical function

1. Round()
    * round a numeric value to the nearest integer or a specific number of decimal places.
    * round(number,[decimals])
2. ceil()
    * same as round but there is not decimal functionality.
    * up to nearest integer 
3. floor()
    * down to nearest integer.

### case 
* case statement: provides condition logic in sql queries, it evaluates condition and return a values when the first condition met(similar to if-then-else).

### CTE's (common table expression)
* CTE is a temporary result set defined within the  execution scope of a single sql stmt;
* its like creating a 'virtual table'

```SQL

     with cte_name as (
        select ...
     )
     select ...
     from cte_name;
```

* usefull for---
  - breaking complex queries into readable parts
  - reusing subquery result
  - recursive queries(like hierarchical data,organisation chart etc.)


## Subqueries

* performance : joins > subquery
* we can also apply the optimization (index,partioning) on joins

* subquery is embedded inside another query and acts as input for that query, subquery are also called inner queries and they can be used in various complex operation in sql.

* a subqueries help in executing queries with dependency on the output of another query, subqueries are enclosed in parentheses.

* IMP : mysql subquery can be used with an outer query which is used as input to the outer query ,it can be used with select ,from and where clause,mysql subquery is executed first before the execution of the outer query.
*  first make logic for inner query then think about outer query.


## JOINs 

1. INNER Join: return rows where there is a match in both tables.
2. LEFT JOIN: return all the rows of left table and also matching row from right table.
3. RIGHT JOIN: all rows from right table,and matching rows from the left, if no match show NULL.
4. FULL JOIN : union of left and right- implemented from UNION
5. CROSS JOIN:return the cartesian product: every row from customers combines with every row from orders.



* syntax of window function in mysql is as follows;

 ```sql
    window_function_name([expression])over(
      [partition by expression]
      [order by expression [asc][desc]]
      [rows or range frame_clause]
    )
 ```

 * window_function_name: which is nothing but the name of your window function ,check this exp which can be row_number.
* partition by : rsult set is devided into partitions, and then the windwo function is applied.
* order by:this defines the order of rows within the each parttion
 ## window function 
### rank functions
    - RANK()
    - DENSE_RANK()
    - ROW_NUMBER()

 1. Row number:
   * ROW_NUMBER():this function is used to assign a unique sequential integert to rows within a partition
   * the first number begins with one.
   * get a unique seq number for each row
   * different ranks for the row having similar values
  ```SQL
      select * ,
      row_number() over (order by salary desc) salaryRank
      from employees;
  ```
  # Difference Between PARTITION BY and ORDER BY in SQL Window Functions

Window functions use the `OVER()` clause, which can include `PARTITION BY` and `ORDER BY`.
These two clauses serve very different purposes.

---

2. PARTITION BY

- Divides the result set into **groups (partitions)**
- Window function is applied **independently to each group**
- Similar to `GROUP BY`, but **does not collapse rows**
- Ranking or aggregation **restarts for each partition**

### Example
```sql
SELECT emp_name,
       department,
       salary,
       RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_rank
FROM employees;
```
3 . RANK()

 - assigns a rank to each row within partition of a result set,the rank of row is specified by one plus the number of ranks that come before it.

```SQL
    select * 
    rank() over (order by salary desc) salaryrank
    from employees
    order by salaryrank
```

## Difference Between RANK() and DENSE_RANK()

| Feature | RANK() | DENSE_RANK() |
|------|--------|-------------|
| Purpose | Assigns rank with gaps | Assigns rank without gaps |
| Handling of ties | Same rank for equal values | Same rank for equal values |
| Next rank after tie | Skips rank numbers | Does not skip rank numbers |
| Ranking sequence | 1, 2, 2, 4 | 1, 2, 2, 3 |
| Common use case | Competition ranking | Leaderboards, exams |
| Output gaps | Yes | No |
| Window function type | Ranking function | Ranking function |

### Example
```sql
SELECT score,
       RANK() OVER (ORDER BY score DESC) AS rnk,
       DENSE_RANK() OVER (ORDER BY score DESC) AS drnk
FROM Scores;
```
### removing duplicate using row_number

 - use window function to identify duplicates and delete them.
 ```SQL
    with duplicate_cte as(
      select employee_id,department_id,salary,
      row_number() over (partition by department_id order by salary) as row_num
      from employees
    )
    delete from employees
    where employee_id in (
      select employee_id from duplicate_cte where row_num>1
    );
 ```

### merge stmt
* in sql there is not native merge stmt .
* but you can simulate the same behavior(insert new rows)

## pivot and unpivot

* pivot = convert rows into table
* unpivot  = convert col into rows
* mysql does't have native pivot but can be simulated with case or  group by 

## Json data handling

## Builing fact & dimension tables

* in stare schema:  defined as -
* dimension tables - descriptive attributes(eg. customer,product,time).
* fact table-> numberic measures(eg. sales,revenue,linked to dimenstions).
* fact table is one who is in center and all the dimension table are connected to it, datawharehouse is designed in this concept.
* fact table store measures and link to dimension via foreign keys.

## Data cleansing

* the process of detecting and correcting ( or removing ) corrupt,inaccurate  data from the database;


## incremental pipeline
* means if we have two table one is source and another is target and we are working or target table, and suppose client made some changes in source file and and we want to reflect these changes in my target table then what we can do 

```SQL
      insert into employees_target (select e1.emp_id,e1.name,e1.department,e1.salary,e1.last_updated
      FROM employees_source e1
      left join employees_target e2 on e1.emp_id = e2.emp_id
      where e2.emp_id is NULL
     );
```


## Stored procedures

* are reusable blocks of sql code that you can call whenever needed.
* we dont need to write query every time( for sql databases not for warehouses)
* call for stored procedure name -> then we call the perticular query



---
---

## slowly changing dimension(SCD)
| Aspect | Type 1 SCD | Type 2 SCD | Type 3 SCD |
|------|-----------|-----------|-----------|
| **Initial Load** | Initial Load | Initial Load, Tracking Established | Initial Load, History Columns Established |
| **New Data Arrives** | Match on Business Key | Match on Business Key | Match on Business Key |
| **If No Match** | Load New Records | Load New Records | Load New Records |
| **If Match** | Replace Old Records | Change Detection | Change Detection |
| **Change Handling** | Overwrites existing data | Mark old version obsolete and add new version | Modify changed records |
| **History Maintained** | ❌ No | ✅ Yes (full history) | ⚠️ Limited history |
| **Typical Use Case** | Correcting errors | Tracking full historical changes | Tracking only selected previous values |

* SCD is a dimension in a data werehouse that changes slowly over time, rather than frequently.


## LAG()
* is a window function that allow partition that allow 

## lead()
* is window function 

---
---

# Optimization

1. ## index
2. ## partition 



## Index:
* indexes are used to retrive data from the database more quickly than othervise,the user cannot see the index, they are just used to speed up seachs/queries.

    ```SQL 
        create index idx_lastname
        on person(lastname);
    ```

* to see index

    ```SQL
    show index from employees;
    ```
*  To drop that index 
    ```SQL
    DROP INDEX index_name;
    ```

## partitions:

* Partitioning = splitting a large table into smaller, manageable pieces (partitions)
* ➡️ based on a column (date, id, region, etc.)
* Partitioning helps the database decide which partition(s) to scan,
not magically jump to a single row in O(1).

### Why use partitioning?

  -  ✅ Faster queries (partition pruning)
  -  ✅ Easier maintenance (drop old data fast)
   - ✅ Better performance on huge tables
  -  ✅ Helps with archival & data lifecycle

  ```SQL
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
```

## Partitioning vs Indexing (Very Important)

| Feature            | Partitioning        | Indexing            |
|--------------------|---------------------|---------------------|
| Purpose            | Data management     | Fast lookups        |
| Works on           | Large tables        | Any size            |
| Storage            | Physical split      | Separate structure  |
| Drop old data      | Instant             | Slow                |
| Replaces index?    | ❌ No               | ❌ No               |


---
---

# OLTP & OLAP

* OLTP : real-time transation system(eg. banking system).
* OLAP: analytical system for reporting(eg. sales dashboard).
* default formate of Hdfs is text formate ,based on hardware 

- dataware hosue api, DFS explaination in modern dataware house ( snowflag,redship)
- database -> single server api-> OLTP -> support acid
- dataware house -> sinlge server api -> OLAP
- modern datawarehouse -> single server api-> OLAP->not acid( beacause its inbuilt on DFS)
- dfs is only storage cant do processing
- apache also give hadoop and spark (open source) to work on dfs 
- spark is 100% faster than hadoop
- spark is expensive
- max spark project.- on databricks only 
* delta lake - only dfs if we want to use acid property when we can use this and inbuit on dfs
* lake house - data lake + delta lake + dataware house 

--

* batch injection pipeline -> exitsting data (tools to bring these data from client to us-apache schoop)
      - periodic data loads
* stream injection pipeline -> live server (tools -> kafka,flink,eventhub ,pubsub to bring data from client)
      - real time data
* we bring these data through pipeline and store it into bronze folder then we decide which folder we need to process
* after the bronze we bring data to silver layer and then at last data goes to gold layer ,where final report will prepare.

## Key principle of lakehouse architecture-

* unified storage layers:
  - stores stuctured(tables), semi-structured(json, logs) and unstructured(image, videos) data in one system
  - typically built on scalable cloud object storage(eg. aws s3,azure,data lake staroge,google cloud storageà);

1. **bronze layer**:this phase marks the input of row data, which is stored as if is collected,usally from varity of sources and in formats such as csv or json,the data is usally row data and varies in quality and structure.

2. **Silver**:at this point, the data is processed and tranformed to achive cleaner,more structred data, task such as filtering,validataion,and normalization,of the data are carried out and stored in efficient formats,this phase may include defined schemas and additional metadata.

  * Key goals:
    - ensure data quality(remove errors,duplicates,inconsistencies).
    - make data query ready for analysis and data scientists.
    - provide a single source of truth for downstream gold layer.

  * Data cleaning technique:
    - NUll handling : 
    - outlier detection : identify and correct extreme values
    - deduplicatio : 
    - data type fixing 
    - standardization
    - validation rules

  * Data quality and governace
    - ensures that data is trustworthy, compliant,and secure,forming the backbone of reliable analytics and ai.
    - quality checks  ensures data is complete, consistent and valid.
    - lineage provide transparency and tracebility.
    - business rules enforce domain -specific logic.
    - PII masking protect senstive information and ensurs compliance.

  * masking technique:
      1. static masking:replace sensitive values permanently

3. **Gold layer**:
* to analysis the data we can use pyspark,spark scala,spark sql , spark java at bronze layer.
* airflow used to craete the workflows,not etl pipelines,for your analysis job ,it is open source,databrick also gives inbuilt function for workflow.
---

## CDC( change data capture)
* change data capture is a technique to track and capture changes( insert ,update,delete) in database so they can be replicated or processed elsewhere.

* purpose:keeps downstream systems(data warehouse,lakehouse,analytics pipelines) in sync with source databases in near real-time.

* common uses: real-time etl pipeline,event-driven application

* datafactory : batch injection as etl service
* all etl tools are 100% code free,from last few years
* two type of analysis after bringing the data -
      1. Batch processing analysis -tools: HIV,Pyspark,Sparksql, ( Data is collected over a period of time and processed all at once)
      2 .Online processing analysis - tools : delta,(Online processing handles real-time user transactions)(nosql,kasandra,hbash,mongodb)
      3. stream proccssing analysis - tools:sparkStreaming (Data is processed continuously as it arrives)(kafka,eventhub,pubsub)
      4. ML processing analysis(DS also can use databricks plateform)- tools:sparkMLIB
* size of hdfs -> n node cluster 
* in batch procss -> data comes and stored in dfs and then data comes in RAM for analysis using spark and then output is stored back to hdfs and then that output file we can send to BA person for report and to client 
* 

## key component of gold layer

  1. fact and dimenstion table
  2. star schema basics
  3. aggregated kpis
  4. connecting to BI tools
  5. business ready curated table

* for streaming analysis we use KAPPA and LAmbda architecture

## tablewise modeling

# Difference Between Conceptual, Logical, and Physical Data Models

Data modeling is done in stages to move from **business understanding** to **actual database implementation**.  
The three main data models are:

- Conceptual Data Model
- Logical Data Model
- Physical Data Model

---

## 1. Conceptual Data Model

### Definition
The **conceptual data model** represents the **high-level business view** of data.  
It focuses on **what data is needed**, not how it is stored.

### Key Characteristics
- Very high-level
- Business-oriented
- No technical details
- No primary keys or foreign keys
- Used by business stakeholders

### Includes
- Entities
- Relationships between entities


## 2. Logical Data Model

### Definition
The **logical data model** describes the **structure of data** in detail but is still **independent of any database system**.

### Key Characteristics
- More detailed than conceptual
- Includes attributes (columns)
- Defines primary keys and relationships
- Normalized (usually up to 3NF)
- No DB-specific details

### Includes
- Entities and attributes
- Primary keys
- Foreign keys
- Constraints




## 3. Physical Data Model

### Definition
The **physical data model** shows **how data is actually stored** in a specific database system.

### Key Characteristics
- Database-specific
- Includes table names, column types
- Indexes, constraints, partitions
- Performance-focused

### Includes
- Tables and columns
- Data types
- Indexes
- Storage details

### Example (MySQL)
```sql
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE
);


* batch processing always support data modeling(star and snowflag schema)

## Grain

* the grain defines the level of detail captured in fact table(eg:one row per product per day per store).

## Surrogate keys vs netural keys

* all system generated identifiers (auto increment ID)
* natural keys:keys derived from business data(customer SSN,product Code).

---

## Brideg tables:

* many to many relationship between dimensions and facts (student enrolled in multiple courses).
* are used to handle many to many relationship in dimension models.instead of forcing a dimenstion to have a one to many relationship with facts.
* a bridge table sits in between to resolve the complexity.


-- all the course taken by the student
select  

  



