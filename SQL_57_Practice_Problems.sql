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


-----------------------INTERMEDIATE---------------------


--20. Categories, and the total products in each category
SELECT
c.category_name,
COUNT(*) AS total_product
FROM products p 
LEFT JOIN categories c ON p.category_id = c.category_id 
GROUP BY 1
ORDER BY 2 DESC

--21. Total customers per country/city
SELECT
country,
city,
COUNT(*) AS total_customers
FROM customers 
GROUP BY 1,2
ORDER BY 3 DESC

--22. Products that need reordering
SELECT
product_id,
product_name
FROM products
WHERE units_in_stock < reorder_level
ORDER BY 1

--23. Products that need reordering, continued
SELECT
product_id,
product_name
FROM products
WHERE (units_in_stock + units_on_order) <= reorder_level
AND discontinued = 0
ORDER BY 1

--24. Customer list by region
SELECT
region,
customer_id,
company_name
FROM customers
GROUP BY region, customer_id
ORDER BY region, customer_id

--25. High freight charges
SELECT
ship_country,
ROUND(CAST(AVG(freight) AS NUMERIC),2) AS freight_average
FROM orders 
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 3

--26. High freight charges - 2015
SELECT
ship_country,
ROUND(CAST(AVG(freight) AS NUMERIC),2) AS freight_average
FROM orders 
WHERE EXTRACT(YEAR FROM order_date) = 1997
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 3

--27. High freight charges with between
SELECT
order_id
FROM orders
WHERE EXTRACT(YEAR FROM order_date) = 1997 

EXCEPT

SELECT
order_id
FROM orders
WHERE order_date BETWEEN '1/1/1997' AND '12/31/1997'

--28. High freight charges - last year
SELECT
ship_country,
ROUND(CAST(AVG(freight) AS NUMERIC),2) AS freight_average
FROM orders
WHERE order_date <= (SELECT MAX(order_date) FROM orders) 
AND order_date >= (SELECT MAX(order_date) - INTERVAL '12 months' FROM orders) 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3

--29. Inventory list
SELECT
o.employee_id,
e.last_name,
o.order_id,
p.product_name,
SUM(od.quantity) AS quantity
FROM orders o 
LEFT JOIN employees e ON o.employee_id = e.employee_id 
LEFT JOIN order_details od ON o.order_id = od.order_id
LEFT JOIN products p ON od.product_id = p.product_id
GROUP BY 3,1,2,4
ORDER BY 3

--30. Customers with no orders
SELECT
c.customer_id
FROM customers c 
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL 

--31. Customers with no orders for EmployeeID 4
SELECT
customer_id,
MAX(CASE WHEN employee_id = 4 THEN 1 ELSE 0 END) AS tally
FROM orders o 
GROUP BY customer_id
HAVING MAX(CASE WHEN employee_id = 4 THEN 1 ELSE 0 END) = 0


------------------------ADVANCED-----------------------

--32. High-value customers
SELECT
c.customer_id,
c.company_name,
od.order_id,
ROUND(CAST(od.unit_price * od.quantity AS NUMERIC),2) AS order_amount
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN order_details od ON o.order_id = od.order_id
LEFT JOIN products p ON od.product_id = p.product_id
WHERE od.unit_price * od.quantity >= 10000
AND EXTRACT(YEAR FROM o.order_date) = 1998
ORDER BY 4 DESC

--33. High-value customers - total orders
SELECT
c.customer_id,
c.company_name,
SUM(ROUND(CAST(od.unit_price * od.quantity AS NUMERIC),2)) AS orders_amount
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN order_details od ON o.order_id = od.order_id
LEFT JOIN products p ON od.product_id = p.product_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1998
GROUP BY 1,2
HAVING SUM(ROUND(CAST(od.unit_price * od.quantity AS NUMERIC),2)) >= 15000
ORDER BY 3 DESC

--34. High-value customers - with discount
SELECT
c.customer_id,
c.company_name,
SUM(ROUND(CAST(od.unit_price * od.quantity * (1-od.discount) AS NUMERIC),2)) AS orders_amount
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN order_details od ON o.order_id = od.order_id
LEFT JOIN products p ON od.product_id = p.product_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1998
GROUP BY 1,2
HAVING SUM(ROUND(CAST(od.unit_price * od.quantity * (1-od.discount) AS NUMERIC),2)) >= 15000
ORDER BY 3 DESC

--35. Month-end orders
SELECT
employee_id,
order_id,
order_date
FROM orders
WHERE order_date = DATE(DATE_TRUNC('month', order_date) + INTERVAL '1 month -1 day')
ORDER BY 1,2

--36. Orders with many line items
SELECT
o.order_id,
COUNT(od.product_id) AS line_items
FROM orders o
LEFT JOIN order_details od ON o.order_id = od.order_id
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 10

--37. Orders - random assortment
SELECT 
order_id
FROM orders 
TABLESAMPLE BERNOULLI (2)

--38. Orders - accidental double-entry
SELECT
o.order_id,
COUNT(*) AS line_count
FROM orders o 
LEFT JOIN order_details od ON o.order_id = od.order_id
WHERE o.employee_id = 3
AND od.quantity > 60
GROUP BY o.order_id
HAVING COUNT(*) > 1

--39. Orders - accidental double-entry details
SELECT 
* 
FROM order_details
WHERE order_id IN (
	SELECT
	o.order_id
	FROM orders o 
	LEFT JOIN order_details od ON o.order_id = od.order_id
	WHERE o.employee_id = 3
	AND od.quantity > 60
	GROUP BY o.order_id
	HAVING COUNT(*) > 1
)

--40. Orders - accidental double-entry details, derived table
SELECT DISTINCT 

--41. Late orders
SELECT
order_id
FROM orders
WHERE required_date < shipped_date
