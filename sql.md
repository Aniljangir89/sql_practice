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

* diff in ram and disk procssing 
* if data in gold layer is in sc formate and layer folder is in datalake which store only nsc data??
