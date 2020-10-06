--1. Which shippers do we have?
SELECT * FROM shippers

--2. Certain fields from Categories
SELECT 
category_name, 
description 
FROM categories

--3. Sales Representatives
SELECT
first_name,
last_name,
hire_date
FROM employees
WHERE title = 'Sales Representative'

--4. Sales Representatives in the United States
