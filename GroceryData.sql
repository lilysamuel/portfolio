SELECT * FROM products

-- Q1. Show the food category names and their descriptions.

select category_name, description
from categories

-- Q2. Show the contact name, address, and city of customers excluding the customers from North America.

select contact_name, address, city
from customers
where Country NOT IN ('USA','Mexico', 'Canada')

-- Q3. Show order date, shipped date, customer id, and Freight of all orders placed in 2017.

select order_date, shipped_date, customer_id, freight
from orders
where order_date >= '2017-01-01' 
       and order_date < '2018-01-01'

-- Q4. Show the Product Name, Company Name, Category Name from the products, suppliers, and categories table

SELECT a.product_name, b.company_name, c.category_name
FROM products a
JOIN suppliers b ON b.supplier_id = a.Supplier_id
JOIN categories c On c.category_id = a.Category_id;

-- Q5. Show the city, company name, contact name from the customers and suppliers table merged together and create a column which contains 'customers' or 'suppliers' depending on the table it came from.

select City, company_name, contact_name, 'customers' as relationship 
from customers
union
select city, company_name, contact_name, 'suppliers'
from suppliers
