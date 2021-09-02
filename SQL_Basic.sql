use classicmodels;


# distinct 
/* SELECT DISTINCT
    select_list
FROM
    table_name
WHERE 
    search_condition
ORDER BY 
    sort_expression;
    */
## querying data from a table I may get duplicate rows
select lastname from employees order by lastname;
## To remove duplicate rows, use the DISTINCT clause in the SELECT statement.
select distinct lastname from employees order by lastname;

## when I use distinct clause to query the states, I will see distinct states and null as follows
select distinct state from customers where state is not null;

## DISTINCT => can use mutiple columns,
select distinct state, city from customers where state is not null order by state, city;

## AND operator
# A and B

select 1 and 0, 0 and 1, 0 and 0, 0 and NULL;

select 1 = 0 and 1 / 0;

select
	customername,
    country,
    state,
    creditlimit
From
	customers
where
	country = 'USA' AND
    state = 'CA' AND
    creditlimit > 100000;
    
# OR operator
# A or B
select 1 or 1, 1 or 0, 0 or 1;
select 0 or 0;
select 1 or null, 0 or null, null or null;

select
	customername,
    country
From
	customers
where
	country = 'USA' or 
    country = 'France';

SELECT   
	customername, 
	country, 
	creditLimit
FROM   
	customers
WHERE(country = 'USA'
		OR country = 'France')
	  AND creditlimit > 100000;

# MySQL IN operator
# The IN operator allows you to determin if a value matches any value in a list of values.

select 1 in (1,2,3);
select 4 in (1,2,3);

select NULL in (1,2,3,null);

SELECT 
    officeCode, 
    city, 
    phone, 
    country
FROM
    offices
WHERE
    country IN ('USA' , 'France');
    
select
	officeCode,
    city,
    phone
from
	offices
where
	country = 'USA' or country = 'France';
    
# NOT IN operator
# NOT operator negates the IN operator

SELECT 
    officeCode, 
    city, 
    phone,
    country
FROM
    offices
WHERE
    country NOT IN ('USA' , 'France')
ORDER BY 
    city;



# Between => Whether is a range or not.

SELECT 
    productCode, 
    productName, 
    buyPrice
FROM
    products
WHERE
    buyPrice BETWEEN 90 AND 100;
    
# LIKE => logical operator that tests whether a string contains a specified pattern or not.

# (%) wildcard at the beginning and the end of the substring
# To check if a string contains a substring
SELECT 
    employeeNumber, 
    lastName, 
    firstName
FROM
    employees
WHERE
    firstName LIKE '%y';

SELECT 
    employeeNumber, 
    lastName, 
    firstName
FROM
    employees
WHERE
    lastName LIKE '%on%';
    
#(_) wildcard start with letter a, end with the letter e, => apple analyae

Select
	employeeNumber,
    lastName,
    firstName
From
	employees
where
	firstName Like 'T_m';
    
# Not like => like operator to find a string that does not match a specific pattern.

# LIMIT offset , row_count

/*
SELECT 
    select_list
FROM
    table_name
LIMIT [offset,] row_count; => offset ~ row_count
*/

SELECT 
    customerNumber, 
    customerName, 
    creditLimit
FROM
    customers
ORDER BY creditLimit DESC
LIMIT 5;

SELECT 
    customerNumber, 
    customerName, 
    creditLimit
FROM
    customers
ORDER BY 
    creditLimit, 
    customerNumber
LIMIT 5;

## n th value => Limit n-1, 1 returns 1 row starting at the row n.
select 
	customerName,
    creditLimit
from
	customers
order by
	creditLimit DESC
Limit 1, 1;

# Double check
select
	customerName,
    creditLimit
from
	customers
order by
	creditLimit DESC
Limit 0, 10;

# is Null, the expression returns true, Otherwise, it returns false.

/* 
SELECT 1 IS NULL,  -- 0
       0 IS NULL,  -- 0
       NULL IS NULL; -- 1
       
SELECT 1 IS NOT NULL, -- 1
       0 IS NOT NULL, -- 1
       NULL IS NOT NULL; -- 0
*/

SELECT 
    customerName, 
    country, 
    salesrepemployeenumber
FROM
    customers
WHERE
    salesrepemployeenumber IS NULL
ORDER BY 
    customerName; 


CREATE TABLE IF NOT EXISTS projects (
    id INT AUTO_INCREMENT,
    title VARCHAR(255),
    begin_date DATE NOT NULL,
    complete_date DATE NOT NULL,
    PRIMARY KEY(id)
);

INSERT INTO projects(title,begin_date, complete_date)
VALUES('New CRM','2020-01-01','0000-00-00'),
      ('ERP Future','2020-01-01','0000-00-00'),
      ('VR','2020-01-01','2030-01-01');

SELECT * 
FROM projects
WHERE complete_date IS NULL;

SET @@sql_auto_is_null = 1;

INSERT INTO projects(title,begin_date, complete_date)
VALUES('MRP III','2010-01-01','2020-12-31');

SELECT 
    id
FROM
    projects
WHERE
    id IS NULL;
    
    
# alias for columns
## column names are so technical that make the qurey's ouput very difficult to understand.

select
	concat_ws(',',lastName, firstname) as 'Full name'
from
	employees;
    
    
select
	e.firstName,
    e.lastName
From
	employees e
order by e.firstName;

# Join clauses
## A relational database consists of multiple related tables linking together using common columns.
/*
MySQL supports the following types of joins
	1. inner join
    2. Left join
    3. Right join
    4. Cross join
    
To join clause is uesd in the select statement appeared after the FROM cluase. 

Setting up sample tables => members, committees

*/
CREATE TABLE members (
    member_id INT AUTO_INCREMENT,
    name VARCHAR(100),
    PRIMARY KEY (member_id)
);

CREATE TABLE committees (
    committee_id INT AUTO_INCREMENT,
    name VARCHAR(100),
    PRIMARY KEY (committee_id)
);

INSERT INTO members(name)
VALUES('John'),('Jane'),('Mary'),('David'),('Amelia');

INSERT INTO committees(name)
VALUES('John'),('Mary'),('Amelia'),('Joe');
## The inner join clause compares each row from the first table with every row from the second table.
## if values from both rows satisfy the join condition, the inner join clause creates a new row whose column contains
## all columns of the two rows from both tables and includes this new row in the result set.
## if the join condition uses the equality operator(=) and the column names in both tables used for matching are the same,
## and you can use the using clause instead;

## inner joins 
select 
    m.member_id, 
    m.name AS member, 
    c.committee_id, 
    c.name AS committee
FROM
    members m
INNER JOIN committees c ON c.name = m.name;

select 
    m.member_id, 
    m.name AS member, 
    c.committee_id, 
    c.name AS committee
FROM
    members m
INNER JOIN committees c using(name);

/*

SELECT
    select_list
FROM t1
INNER JOIN t2 ON join_condition1
INNER JOIN t3 ON join_condition2
...;

First, specify the main table that appears in the FROM cluase (t1)
Second, specify the table that will be joined with the main table, which appears in the INNER JOIN cluase (t2, t3)
Third, specify join condition after the ON keyword of the inner join cluase. The join condition specifies the rule of the matching rows
between the main table and the table appeared in the inner join cluase.

*/

SELECT 
    productCode, 
    productName, 
    textDescription
FROM
    products t1
INNER JOIN productlines t2 
    ON t1.productline = t2.productline;

## INNER join with group by cluase example
SELECT 
    t1.orderNumber,
    t1.status,
    SUM(quantityOrdered * priceEach) total
FROM
    orders t1
INNER JOIN orderdetails t2 
    ON t1.orderNumber = t2.orderNumber
GROUP BY orderNumber;

# three tables
SELECT 
    orderNumber,
    orderDate,
    orderLineNumber,
    productName,
    quantityOrdered,
    priceEach
FROM
    orders
INNER JOIN
    orderdetails USING (orderNumber)
INNER JOIN
    products USING (productCode)
ORDER BY 
    orderNumber, 
    orderLineNumber;
    
    
## Left joins

SELECT 
    m.member_id, 
    m.name AS member, 
    c.committee_id, 
    c.name AS committee
FROM
    members m
LEFT JOIN committees c USING(name);

## Right join
SELECT 
    m.member_id, 
    m.name AS member, 
    c.committee_id, 
    c.name AS committee
FROM
    members m
RIGHT JOIN committees c USING(name);












