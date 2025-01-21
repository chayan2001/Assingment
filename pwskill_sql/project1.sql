create database sql_project
---question 1
create table employee
(
emp_id int8 primary key,
emp_name char(50) NOT NULL,
age int, CHECK (age>=18),
email varchar(255) UNIQUE,
salary int8 DEFAULT 30000

)
select * from employee
---question 2
--Constraints in a database are rules that ensure data integrity by maintaining accuracy, consistency, and reliability. They limit the type of data that can be entered, preventing errors. Common types of constraints include:

--1. Primary Key: Ensures unique, non-null identifiers for rows.
--2. Foreign Key: Maintains relationships between tables.
--3. Unique: Ensures all values in a column are distinct.
--4. Not Null: Ensures a column cannot have null values.
--5. Check: Validates data based on specific conditions.
--6. Default: Assigns default values when none are provided. These constraints help prevent data inconsistencies and errors.
-- question 3
--The **NOT NULL** constraint ensures that a column always contains a value, preventing incomplete records. A **primary key** cannot contain NULL values because it must uniquely identify each record in a table, and NULL values are not unique, which would violate the integrity of the primary key.
--question 4
--To **add** a constraint, use `ALTER TABLE` followed by `ADD CONSTRAINT`. To **remove** a constraint, use `ALTER TABLE` followed by `DROP CONSTRAINT`.

Example:
-- Add: `ALTER TABLE employees ADD CONSTRAINT pk_employee_id PRIMARY KEY (employee_id);`
-- Remove: `ALTER TABLE employees DROP CONSTRAINT pk_employee_id;`

--question 5 
--Violating constraints during insert, update, or delete operations causes errors, preventing invalid data from being added or modified. For example, attempting to insert a duplicate value into a column with a `UNIQUE` constraint triggers an error like: 

--`ERROR: duplicate key value violates unique constraint "pk_employee_id"`.
-- question 6
--alter table 
--add constrain pk_prodict_id primary key (product_id);
--alter table
--add column price set default 50.00 ; 
--question 7
--select c.student_name , c.class_name from Students as s
--inner join classes as c
--on table s.class_id = c.class_id
--question 8
--select o.order_id , c.customer_name from orders as o
--inner join customers as c
--on table o.customer_id = c.customer_id
------------------------------------------------------------------
--select p.product_name , p.order_id from orders as o 
--inner join products as p
--on table o.order_id = p.order_id
--question 9 
--select sum(amount) from sales as s
--inner join products as p
--on table s.product_id = p.prducts.id 
--question 10
--select o.order_id ,c.customer_name,c.customer_name from orders as o
--inner join customers as c
--on table o.customer_id = c.customer_id
--inner join orders_details as od
--on table o.order_id = od.order_id