-- ==========================================
-- Advanced SQL Retail Customer Insights Project
-- Database: retail
-- ==========================================

CREATE DATABASE retail;
USE retail;

-- ==========================================
-- Create Table
-- ==========================================

CREATE TABLE orders (
order_id INT,
customer_name VARCHAR(50),
city VARCHAR(50),
category VARCHAR(50),
order_date DATE,
sales INT
);

-- ==========================================
-- Insert Data
-- ==========================================

INSERT INTO orders VALUES
(1,'Rahul','Hyderabad','Electronics','2024-01-10',50000),
(2,'Priya','Chennai','Furniture','2024-01-12',30000),
(3,'Ajay','Hyderabad','Electronics','2024-02-05',45000),
(4,'Neha','Bangalore','Clothing','2024-02-18',20000),
(5,'Rahul','Hyderabad','Accessories','2024-03-01',15000),
(6,'Priya','Chennai','Furniture','2024-03-10',25000),
(7,'Ajay','Mumbai','Electronics','2024-03-15',60000);

-- ==========================================
-- Basic Queries
-- ==========================================

SELECT * FROM orders;

SELECT SUM(sales) AS total_revenue
FROM orders;

SELECT customer_name, SUM(sales) AS total_sales
FROM orders
GROUP BY customer_name
ORDER BY total_sales DESC;

SELECT city, SUM(sales) AS city_sales
FROM orders
GROUP BY city;

SELECT category, SUM(sales) AS category_sales
FROM orders
GROUP BY category
ORDER BY category_sales DESC;

-- ==========================================
-- Advanced Queries
-- ==========================================

-- Top 3 Customers
SELECT customer_name, SUM(sales) AS revenue
FROM orders
GROUP BY customer_name
ORDER BY revenue DESC
LIMIT 3;

-- Monthly Revenue
SELECT MONTH(order_date) AS month_no,
SUM(sales) AS revenue
FROM orders
GROUP BY MONTH(order_date)
ORDER BY month_no;

-- Cities Above 50000 Revenue
SELECT city, SUM(sales) AS revenue
FROM orders
GROUP BY city
HAVING revenue > 50000;

-- Customer Ranking
SELECT customer_name,
SUM(sales) AS revenue,
RANK() OVER (ORDER BY SUM(sales) DESC) AS ranking
FROM orders
GROUP BY customer_name;

-- Sales Classification
SELECT order_id,
sales,
CASE
WHEN sales >= 50000 THEN 'High'
WHEN sales >= 25000 THEN 'Medium'
ELSE 'Low'
END AS sales_level
FROM orders;

-- ==========================================
-- Window Functions
-- ==========================================

-- Running Total
SELECT order_id,
sales,
SUM(sales) OVER (ORDER BY order_id) AS running_total
FROM orders;

-- Previous Sale
SELECT order_id,
sales,
LAG(sales) OVER (ORDER BY order_id) AS previous_sale
FROM orders;

-- Difference from Previous Sale
SELECT order_id,
sales,
sales - LAG(sales) OVER (ORDER BY order_id) AS difference
FROM orders;

-- Dense Rank
SELECT customer_name,
SUM(sales) AS revenue,
DENSE_RANK() OVER (ORDER BY SUM(sales) DESC) AS rank_no
FROM orders
GROUP BY customer_name;

-- Revenue Share %
SELECT customer_name,
SUM(sales) AS revenue,
ROUND(SUM(sales)*100/(SELECT SUM(sales) FROM orders),2) AS percent_share
FROM orders
GROUP BY customer_name;

-- ==========================================
-- Customer Analytics
-- ==========================================

-- Repeat Customers
SELECT customer_name,
COUNT(*) AS total_orders
FROM orders
GROUP BY customer_name
HAVING COUNT(*) > 1;

-- First Purchase
SELECT customer_name,
MIN(order_date) AS first_purchase
FROM orders
GROUP BY customer_name;

-- Last Purchase
SELECT customer_name,
MAX(order_date) AS last_purchase
FROM orders
GROUP BY customer_name;

-- Lifetime Value
SELECT customer_name,
COUNT(*) AS total_orders,
SUM(sales) AS lifetime_value
FROM orders
GROUP BY customer_name
ORDER BY lifetime_value DESC;

-- Customer Segmentation
SELECT customer_name,
SUM(sales) AS revenue,
NTILE(3) OVER (ORDER BY SUM(sales) DESC) AS segment
FROM orders
GROUP BY customer_name;

-- ==========================================
-- Views
-- ==========================================

CREATE VIEW top_customers AS
SELECT customer_name,
SUM(sales) AS revenue
FROM orders
GROUP BY customer_name;

SELECT * FROM top_customers;
