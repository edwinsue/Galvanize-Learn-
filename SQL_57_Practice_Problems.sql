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
SELECT
first_name,
last_name,
hire_date
FROM employees
WHERE title = 'Sales Representative'
AND country = 'USA'

--5. Orders placed by specific EmployeeID
SELECT
order_id,
order_date
FROM orders
WHERE employee_id = 5
ORDER BY 2 

--6. Suppliers and ContactTitles
SELECT
supplier_id,
contact_name,
contact_title
FROM suppliers
WHERE contact_title NOT LIKE 'Marketing Manager'

--7. Products with “queso” in ProductName
SELECT
product_id,
product_name
FROM products
WHERE LOWER(product_name) LIKE '%queso%'

--8. Orders shipping to France or Belgium
SELECT
order_id,
customer_id,
ship_country
FROM orders
WHERE LOWER(ship_country) IN ('france','belgium')

--9. Orders shipping to any country in Latin America
SELECT
order_id,
customer_id,
ship_country
FROM orders
WHERE LOWER(ship_country) IN ('brazil','mexico','argentina','venezuela')

--10. Employees, in order of age
SELECT
first_name,
last_name,
title,
birth_date
FROM employees
ORDER BY birth_date 

--11. Showing only the Date with a DateTime field
SELECT
first_name,
last_name,
title,
CAST (birth_date AS DATE)
FROM employees
ORDER BY birth_date

--12. Employees full name
SELECT
first_name,
last_name,
first_name || ' ' || last_name AS full_name
FROM employees

--13. OrderDetails amount per line item
SELECT
order_id,
product_id,
unit_price,
quantity,
ROUND(CAST(unit_price * quantity AS NUMERIC),2) AS total_price
FROM order_details
ORDER BY 1,2

--14. How many customers?
SELECT 
COUNT(DISTINCT customer_id) AS total_customers
FROM customers

--15. When was the first order?
SELECT
MIN(order_date)
FROM orders

--16. Countries where there are customers
SELECT
country
FROM customers
GROUP BY 1
ORDER BY 1

--17. Contact titles for customers
SELECT
contact_title,
COUNT(*)
FROM customers
GROUP BY 1
ORDER BY 2 DESC

--18. Products with associated supplier names
SELECT
p.product_id,
p.product_name,
s.company_name
FROM products p 
LEFT JOIN suppliers s ON p.supplier_id = s.supplier_id
ORDER BY 1

--19. Orders and the Shipper that was used
SELECT
o.order_id,
o.order_date,
s.company_name
FROM orders o
LEFT JOIN shippers s ON o.ship_via = s.shipper_id
WHERE order_id < 10300
ORDER BY 1 