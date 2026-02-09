

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

### Data lake :
- A data lake is a storage system that holds large amounts of raw data in its original format, whether structured, semi-structured, or unstructured, so it can be used later for analysis.

## Delta Lake 
* Think of Delta Lake as a smart notebook on top of a messy pile of papers (your data lake).
* A data lake (DFS = distributed file system, like S3/HDFS) is like a huge pile of papers: anyone can dump things, files can be messy, and it’s hard to keep track.
* Delta Lake adds rules to this notebook:
     -   It tracks changes (ACID transactions) → nothing gets lost or messed up.
     -   You can update, delete, or go back in time → like being able to undo a page you wrote.
     -   It makes messy files reliable and query-friendly.
✅ Key point: You only need Delta Lake if you want ACID properties (reliable transactions) on top of your plain data lake. Otherwise, just using DFS (S3/HDFS) is fine for storing raw data

## Lake house
* Now, a Lakehouse is like a super-organized office:
      -  Data Lake: Raw messy papers stored in bulk.
      -  Delta Lake: A smart notebook on top of it with rules and versioning.
      -  Data Warehouse: A polished filing cabinet for clean, ready-to-use reports and analytics.
* So a Lakehouse = Data Lake + Delta Lake + Data Warehouse functionality:
     - You can store raw data (data lake)
     - Keep it reliable and query-ready (Delta Lake)
     - Run analytics/reporting like a warehouse

## why we use etl in dataware house and elt in data lake why not only one ?
  -  ETL is needed for structured, pre-cleaned data in data warehouses.
   - ELT is needed for raw, flexible, large-volume data in data lakes.
   - Different use-cases: one method cannot efficiently serve both structured and raw/unstructured data.

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
## two type of analysis after bringing the data -
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
```

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


-------------



### ETL – Extract, Transform, Load

* Data is transformed before loading into the warehouse

- Source → ETL Tool → Transform → Data Warehouse

### ELT – Extract, Load, Transform

* Data is loaded first
* Transformation happens inside the warehouse

-  Source → Data Warehouse → Transform (SQL)

* etl opensource tool -> sqoop


### what we need from source to establise connection:
* IP
* PORT
* username
* password
* database name
* table name 
 - grant ?
### for target:
* HDFS(aws,azure,gcp)
*  10+19+=29

## HDFS
* cluster->datacenter->racks->nodes
* each node size>15GB
* one name node(master node) other need to report to name node in each 3 sec ,it holds the meta data of other nodes
* master node devide file into multiple blocks,and distribute it every where and replicates it 3 times,so dfs give fault tolerance.
* block size is 128mb
* not same block is stored in multiple nodes
* master machine is also 2,3 
* The Hadoop Distributed File System (HDFS) is a scalable and fault-tolerant storage solution designed for large datasets. It consists of NameNode (manages metadata), DataNodes (store data blocks), and a client interface. Key advantages include scalability, fault tolerance, high throughput, cost-effectiveness, and data locality, making it ideal for big data applications.

## HDFS -blocks
* fits well with replication to provide foult tolerance and avalilablity
* adv of blocks:
  - fixed size - easy to calculate how many fit on a disk
  - a file can be larger tahn any. single disk in the network
  - if a file or a chunk of the fil eis smaller than the block size, only need space is used 
  - number of blocks is = number of task executing parallely
* name node is always out of rack
* SNN -> stand by name node
* ANN -> Active name node

![alt text](<images/Screenshot 2026-02-03 at 3.17.58 PM.png>)

## Staging area in etl

* in etl a staging area is temporary storage zone where raw data from multiple source is collected,cleaned and transformed before being loaded into the target data warehouse.It acts as a buffer between source system and the warehouse,ensureing data  quality and consistency

* why testing is required: prevent data loss,duplication or corruption ,ensure data quality for analysis and reporting,detect issues early in the pipeline,,reducing downstream errors

## ETl testing workflow
 - requirement analysis:understand source,transoformation,and target schema.
 - test planinig:defines test cases,scope
 - test design:create sql querys
 - test execution:run test on staging/warehouse
 - defect reporting:log mismatches or transformation errors
 - regression testing:revalidate after fixes.
 - sign-off: confirm data quality before production

 ## type of etl test
 - source to target mapping validation:ensure field map correctly
 - data completeness:all records are loaded without loss.
 - data acuracy:values match expected resultafter transformation
 - data transformation validataion:business rules applied correctly.

* in hadoop mapreduce execute result
* in spark sparkcore execute result
  


  * snowflake is cloud data warehouse.
  * Cloud storage is object storage, not HDFS. HDFS only exists if you intentionally run Hadoop.



| Cloud Platform         | Storage Service Name                   |
|------------------------|----------------------------------------|
| **AWS**                | **Amazon S3 (Simple Storage Service)** |
| **Azure**              | **Azure Blob Storage**                 |
| **Google Cloud (GCP)** | **Google Cloud Storage (GCS)**         |

---
---

* to analysis data from dfs name of hadoop engine is mapreduce (to analysis big data recommanded framework - hadoop 2.x ,3.x)
* hadoop 1.x - only single name node supports ( no availability,no resource management) to overcome this apache said we gives 2.x and 3.x version
* after that no one uses 1.x ,after that hadoop ads **YARN** library in 2.x and 3.x to overcome single point failer.
* yarn work with multiple name node( to work with ANN and SNN)
* if two name node works then definetly yarn will be there, gives resource managment and high availability.
* components of hadoop ecosystem : sqoop,flume,hive,pig,(execpt hbase),ooziee they cant work without mapreduce engine they need to work with mapreduce. 
* hdfs nows only mapreduce program only.(only for hadoop cluster ).
* scoop is used to bring existing data from client db to target.
* flume is used to bring live server data to hdfs(expird because of kafka).
* hive is data analysis tool,this is like a dataware house,we use 100%.sql lang for that but name will **HIVQL**
* PIG : this is scripting lang used to analysis the data(expired)
* ooziee:used for create workflow(expired because of airflow)
* hbase : this is nosql used for online processing,this is not executing through map reduce, this work directly with hdfs.
* these all name of animal and apache gives the zookeaper to manage all the components of hadoop
* now we are not uses mapreduce because it takes more line of code,but we still use this concept of mapreduce,so we use **HIV** instead of mapreduce but it works throgh mapreduce not directly,
* but hbase works directly with hdfs, this is OLAP
* if we want hadoop big data analysis then hiv and hbase are important  data analysis tools .
* hadoop do only 2 type of analysis - batch(hive) and live(hbase).

---
## Hadoop 1.x architecure

- master slive api?
* in map reduce n tasktracker on n nodes - used to process the data in hdfs
* job tracker is also there to manage tasktraker
* when we run hiv and mapreduce program in hadoop analysis,then jobtracker takes responsibility,and ask to name node ,then name node give info to jobtracker and then job tracker assign task to all these task tracker( these an jvm machines) then these tasktracker goes to these data node besed on their job and run thier logic and gives result back to job tracker.
* limititation - FIFO
![alt text](<images/Screenshot 2026-02-04 at 12.45.24 PM.png>)


---
## Hadoop 2.x Yarn achitecture

* every data node have one node manager
* resource manager takes the request from us .this is connected with ANN and SNN.
* per job resource manager release one application master and then applicataion master ask resrouce manager(RM) - " ki bhai mujhe node mangaers chahiye appn kam krane ke liye"
* these node manger executes the task and gives the result back to application manager.
![alt text](<images/Screenshot 2026-02-04 at 1.01.23 PM.png>)


---
---

## HBASE(NO SQL)

* this is column oriented
* no need to mapreduce direct intarect with hdfs using hbase api
* used for online processing of big data
* this is adoop framework so it executes task in disk only 

---

## Hive dataware house articheture
![alt text](<images/Screenshot 2026-02-04 at 3.00.43 PM.png>)

* hive is dataware house so it is OLAP.
* when we write query then first logic of query is excutes first in warehouse then conveted in mapreduce program 
* then that mapreduce program will run in hdfs.
  
---

## Spark yarn architecture

* in spark : sparkcore(spark driver) -> yarn -> hdfs
* we can use sparksql,pyspark,sparkscala,sparkjava..
* this sparkcore engine is multiple lang api that support multiple api's.
* all the blocks including replica are loaded into ram of that nodes
* spark input is RDD(resielent distrbuted dataset)
* so all the content of ram is in rdd so that my pyspark logic will run on RDD.
* sparkcore take request from us and report to resouce manager.
- The YARN ResourceManager allocates resources to Spark executors, not directly to RDDs.
- Spark executors execute tasks on RDD partitions based on the logic defined in the Spark application.
- Intermediate results are processed and kept in memory (or spilled to disk if needed), reducing disk I/O.
- Results are written to HDFS or other storage systems only when explicitly specified by an action.
- This in-memory processing model is why Spark is significantly faster than Hadoop MapReduce.
- pyspark input data frame




```text
Client (PySpark / Spark SQL / Scala / Java)
        |
        v
Spark Driver (Spark Core)
        |
        v
YARN ResourceManager
        |
        v
NodeManagers
        |
        v
Executors (run tasks on data from HDFS)
```

---

## HDFS commands

*  hadoop fs -mkdir retails (create dir in hdfs)
*  hadoop fs -ls retails (to list files fo directory) 
*  hadoop fs -mkdir retails/salesdata (create subdir in hdfs)
*  hadoop fs -rmr retails/salesdata (remove the dir from hdfs)
*  hadoop fs -ls retails
*  hadoop fs -put ramdata.txt retails
* hadoop fs -ls retails 
* how to check about the hadoop blocks : hadoop fsck / -blocks

## safe mode

* go to the current safe node status
* hadoop dfsadmin -safemode get : check if safe mode is off or not 

## HIVe 
* hiv is olap but not oltp
* hiv is used to analysis any large value of structured and sem structred data.
* hiv default storage is dfs
* when we run hive querys then in backend that query convert into mapredure program
* to maintain schema hive use metastore.
* there are 2 type of datatypes in hive -
      1. primitive - int,float,double,long,strign
      2. complex datatype - struct, map, array
   
* hive and hadoop are extensively used in face book for different kind of operations. around 700TB
* think of other application model that can levarge hadoop MR

## HIVE commands and function 

* hive support all mysql command and function except insert,uptate,delete
* before loading the data table from hdfs to hive ware house we need to create schema for that.
  
### there are two type of tables in dataware house :

* 1. internal tables(managed tables):tables which are storring in dw is called internal tables.recommanded for analysis
* 2. external tables(unmanagable tables):tabels data storing in external location ei hdfs or localfilesystem
  * how to create external tables :
    ```text
        retails/ram.csv
    ```

    ```hive
      create external table abc(id int,city string,country string) row format delimited fields terminated by ',' location retails/ram.csv
      select  * from abc;
    ```

* once internaltabel analysis done the op of internal table analysis we will take into the external tables to these external tables >> bi->reports

```hive
  create external table myexteb(schema data...) row formate delimited fields terminated by ',' /user/hadoop/retails/salesdata/xy.txt;
  insert overwrite table myexteb select  * from interx where country = 'india';
```


# Hive Internal → External Table Workflow Example

Let’s do a **hands-on example** step by step, to see how internal → external → BI flow works in Hive. We'll use a small warehouse/sales dataset.

---

## Step 0: Sample CSV File

Create `sales.csv` on Linux:

```csv
sale_id,product,quantity,price,country
1,Apple,10,100,India
2,Banana,20,50,USA
3,Orange,15,80,India
4,Mango,5,200,UK
5,Apple,25,100,India
```
* create internal table
```hive
      CREATE TABLE sales_internal (
          sale_id INT,
          product STRING,
          quantity INT,
          price INT,
          country STRING
      )
      ROW FORMAT DELIMITED
      FIELDS TERMINATED BY ','
      STORED AS TEXTFILE;
```

* Load CSV into Internal Table
```hive
      LOAD DATA LOCAL INPATH '/home/hadoop/sales.csv' 
      INTO TABLE sales_internal;
```

* verify data

```hive
  SELECT * FROM sales_internal;
```

* Step 2: Analysis on Internal Table


```hive
      SELECT product, SUM(quantity*price) AS total_sales
      FROM sales_internal
      WHERE country='India'
      GROUP BY product;
```

* Step 3: Create External Table (for BI)
```hive
    CREATE EXTERNAL TABLE sales_india (
        product STRING,
        total_sales INT
    )
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    STORED AS TEXTFILE
    LOCATION '/user/hadoop/retails/salesdata/india';

```
* Step 4: Move Data to External Table

```hive
        INSERT OVERWRITE TABLE sales_india
        SELECT product, SUM(quantity*price) AS total_sales
        FROM sales_internal
        WHERE country='India'
        GROUP BY product;
```
* Now your external table contains the analyzed data.

* Step 5: Query External Table

``` hive
SELECT * FROM sales_india;
```
* Hive does not combine all table data into the same folder. Each table points to its own location.

* TBLPROPERTIES ("skip.header.line.count"="1"); why this? : if data is in file contains column so we need to skip that row .


### to create parquet file for hive optimization
```text
    create table myparq(
      id int,
      name string,
      age int
    )
    stored as parquet
```

```text
    insert overwrite table myparquet select * from xyz
```

## HIVE Partitions:
* using to increase the performace of query execution 
* partition : large table
* partition : partitioned by(colomnname datatye)
* note : create partition tabels for existing tabels(internal tables) of dw
* partition not default in hive dw so we activate the partition lib in hive dw using set commands before overwrite the internal table to partition table.
* partititon column are storing in dw as directories(ie  ever unique value of the column storing as directory in hive dw)

      ```text
         create table mypart(id int,country string) partitioned by (city string) row formate delimited fields terminated by ',';


         SET hive.exec.dynamic.partition = true;
         SET hive.exec.dynamic.partition = nonstrict;


         insert overwrite table mypart partition(city) select id,country,city from xyz;

         select * from mypart; 
      ```
* to overcome the drawbacks fo partitions : Bucketing
* bucketing : we can choose num of buckets
* clustered by:bucketing
* patitioned by: partition
* note : bucketing columns are storing in dw as a files 
* note: to create the bucketing isnot default dw so we have to activate bucketing using set commands before overwrite the bucketing table from nonbucketing table
* we will create bucketing table from existing table(internal table of hive dw )

---

```text
    create table mybucket(id int,city string,country strign) clustered by(city) into 3 buckets row formate delimited field terminated by ',';

    set hive.enforce.bucketing  = true;
    insert overwrite table mybucket select id,city,country  from xyz;
    select * from mybucket;
    exit;
    hadoop fs -ls /user/hive/warehouse/mybucket
```
* note : tablesample: inbuild keyword for bucketing analysis(sample queries);
* select id from mybucket tablesample(bucket 1 out of 3 on city);
  
---
### Indexing
* create index myfirstindex on table sales(city) as 'org.apache.hive.ql.index.compact.CompactIndexHandler' with  deferred rebuild
* display indexs of specific tables;
  ```text
     show formatted index on sales;
  ```
---
### temporary tables:

```text
  create view abc as select id,city from emp where country = 'india'
  select * from abc;

```


---
---

### map side join(preferred when possible)
* one dataset is small(fits it memory)
* date is pre stored and partitioned on the join key.
* example:joining a largr transaction log with a small customer reference table.
  
### reduce-side join(fallback option ):
* both dataset are large and cant fit into memory.
* no preprocessing guarantee(unsorted,unpartitioned data).
* example:joining two massive log file across multiple keys.


## to load json data 
* we need to use jsonSerde (serializer/desericalizer)
CREATE EXTERNAL TABLE sales_json (
    sale_id INT,
    product STRING,
    quantity INT,
    price INT,
    country STRING
)
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
STORED AS TEXTFILE
LOCATION 'sales/fold3';

## what json serde in hive?
* SerDe = serializer/Deserializer -> defines how hive read/write data


## HIVE TO HDFS
      ```text
          insert overwrite directory 'retails/myfile.csv' select * from emp;
      ```


-------
------

### Spark

* inputs datastructure:
   1. rdd : any formate ,faulttooler, immuable,rdd:limited performance
   2. df: structured data,semi structure (df>rdd)
   3. dataset: extension of df, opps api
  
* RDD analysis ( batch proccesing ): pyspark

### there is 3 way to create the rdd

1. using parallelize(): directly we can pass any list data into menory 
    - syntax: sc.parallelize([1,2,3,4])
    - NOTE: sc(spark context) is sparkapi lib using to define the sparkdriver
2. from hdfs file.
3. from exsting data.

### Spark : 2type of function 
1. tranformations
    - narrow transformation : map level(spilt,condition)-> map,flatmap,mappartition,filter,sample,union
    - wide transformation : reduce level(aggregations)->intersection,distinct,reduceByKey,GroupByKey,Join,Cartesian,Repartition,Coalesce
2. actions:to display or save to rdd to hdfs->count(),collect(),saveAsTextFile(),first()
  
* NOTE: spark is LAZY evaluation?:spark job will not execute untill you trigger the action function 
* NOTE: spark Engine by default create the one DAG per job 
  -  DAG: set of stages
  - sum of stages: num of wide transformation +1
* DAG:using to debugging the spark job to check the stages of job

![alt text](<images/Screenshot 2026-02-09 at 12.42.37 PM.png>)

* one block = one partition
* to verify the number of partition of rdd
    ```text
        xyz.getNumPartitions()
    ```
* to reduce the number of partition of RDD
    ```text
        abc.getNumPartitions()
    ```
* to increase the number of partition 

   ```text
      rama = abc.repartition(4)
   ```

* df is already optiomized so that df is faster but in rdd we neet to use partitions to optimize it.
* lots of garbage collection so that performance of rdd will decreases
* for analysis of unsturctured data then only we choose rdd 

    ```text
        words = sc.parallelize(['ram','anil','anil','rakesh'])
        words.getNumPartitions()
        words_filter  = words.filter(lambda x:'anil' in x )
        words_filter.collect()
    ```

* map:using to form data as key,value pair or split data with delimiter
* flatmap:using to split content of file with specific delimiter
  
### how to create rdd of exiting hdfs fil e

* note: if any rdd is reusable to solve the multiple problem then we can keep the rdd in memory only using CACHE()
* PARSIST() : in memory and disk
* once analysis done on rdd u can uncache the rdd using uncache()
* cache() is optimization technique to increase the performance of execution
# Spark RDD vs DataFrame (DF)

## Overview
Apache Spark provides two main abstractions for distributed data processing:
- RDD (Resilient Distributed Dataset)
- DataFrame (DF)

---

## Comparison Table

| Feature | RDD | DataFrame (DF) |
|-------|-----|----------------|
| Data Type | Unstructured | Structured / Semi-structured |
| Schema | No schema | Schema-based |
| Performance | Limited performance | Better performance |
| Optimization | No built-in optimization | Built-in optimization (Catalyst Optimizer) |
| API Level | Low-level API | High-level API |
| Ease of Use | Complex | Easier and more expressive |
| Language Support | Scala, Java, Python | Scala, Java, Python, SQL |

---

## Operations

### RDD
- Uses **Transformations** and **Actions**
- Supports:
  - `cache()`
  - `partition()`
- Shared Variables:
  - Broadcast variables
  - Accumulators

rdd.map(lambda x: x * 2).collect()
```
## Homework: 
* 1. find the avg word length?

   

## architecture of spark SQL

![alt text](<images/Screenshot 2026-02-09 at 4.11.06 PM.png>)



