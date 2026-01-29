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