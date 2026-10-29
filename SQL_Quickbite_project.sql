create database quickbite;

-- understanding the customer table --
select * from customers;             -- displaying all customers--
select count(*) from customers;       -- displaying the count of customers--
describe customers;                    -- understanding the customers table  
SELECT * FROM customers WHERE customer_id IS NULL and customer_name IS NULL and city IS NULL and customer_segment IS NULL;    -- cheching for null values

-- understanding the menu_items table --
select * from menu_items;
select count(*) from menu_items;
describe menu_items;
SELECT * FROM menu_items WHERE item_id IS NULL and restaurant_id IS NULL and item_name IS NULL and category IS NULL and price is null;

-- understanding the orders table --
select * from orders;
select count(*) from orders;
describe orders;
SELECT * FROM orders WHERE order_id IS NULL and customer_id IS NULL and restaurant_id IS NULL and order_date IS NULL and order_status is null and delivery_minutes is null and order_amount is null and discount is null;

-- understanding the payments table --
select * from payments;
select count(*) from payments;
describe payments;
SELECT * FROM payments WHERE payment_id IS NULL and order_id IS NULL and payment_method IS NULL and payment_status IS NULL and payment_date is null;

-- understanding the restaurants table --
select * from restaurants;
select count(*) from restaurants;
describe restaurants;
SELECT * FROM restaurants WHERE restaurant_id IS NULL and restaurant_name IS NULL and city IS NULL and cuisine IS NULL and rating is null;

SELECT * FROM orders WHERE order_amount < 0;     -- finding invalid order amounts --
SELECT distinct order_status FROM orders;         -- checking the order statuts--
SELECT DISTINCT payment_status FROM payments;      -- checking the payment statuts--


-- CUSTOMER ANALYSIS --

SELECT COUNT(*) AS total_customers FROM customers;                    -- Total Number of Customers--

SELECT COUNT(DISTINCT customer_id) AS customers_with_orders FROM orders;               -- Customers Who Placed Orders--

SELECT COUNT(*) AS customers_without_orders FROM customers c LEFT JOIN orders o 
ON c.customer_id = o.customer_id WHERE o.order_id IS NULL;                             -- customers_without_orders

SELECT city, COUNT(*) AS total_customers FROM customers 
GROUP BY city ORDER BY total_customers DESC;                                          -- Customers count by city--

SELECT customer_segment, COUNT(*) AS total_customers FROM customers 
GROUP BY customer_segment ORDER BY total_customers DESC;                               -- customers count by customer segment--

SELECT customer_id, COUNT(*) AS total_orders FROM orders GROUP BY customer_id HAVING COUNT(*) > 1;     -- customers who placed multiple orders--


-- RESTAURANT ANALYSIS --

SELECT COUNT(*) AS total_restaurants FROM restaurants;                        -- total restaurants--

SELECT city, COUNT(*) AS total_restaurants FROM restaurants GROUP BY city ORDER BY total_restaurants DESC;   -- Restaurants by City--

SELECT cuisine, COUNT(*) AS total_restaurants FROM restaurants GROUP BY cuisine ORDER BY total_restaurants DESC;      -- Restaurants by cusine--

SELECT AVG(rating) AS average_rating FROM restaurants;           -- average ratings--

SELECT restaurant_name, rating FROM restaurants ORDER BY rating DESC LIMIT 5;      -- Top 5 Highest-Rated Restaurants--


-- ORDER ANALYSIS--

SELECT COUNT(*) AS total_orders FROM orders;            -- total order --

SELECT order_status, COUNT(*) AS total_orders FROM orders 
GROUP BY order_status ORDER BY total_orders DESC;                     -- How many orders are in each status?--

SELECT AVG(order_amount) AS average_order_amount FROM orders;       -- average order amount--

SELECT restaurant_id, COUNT(*) AS total_orders FROM orders 
GROUP BY restaurant_id ORDER BY total_orders DESC;                  -- Which restaurants receive the most orders?--

SELECT AVG(delivery_minutes) AS average_delivery_time FROM orders;      -- average delivery time--


-- REVENUE ANALYSIS--
 
SELECT SUM(order_amount) AS total_revenue FROM orders WHERE order_status = 'Delivered';     -- total revenue--

SELECT restaurant_id, SUM(order_amount) AS total_revenue FROM orders WHERE order_status = 'Delivered'
GROUP BY restaurant_id ORDER BY total_revenue DESC;                   -- Which restaurants generate the highest revenue?--

SELECT r.city, SUM(o.order_amount) AS total_revenue FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.order_status = 'Delivered' GROUP BY r.city
ORDER BY total_revenue DESC;                                         -- Which cities generate the most revenue?--

SELECT r.cuisine, SUM(o.order_amount) AS total_revenue FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.order_status = 'Delivered' GROUP BY r.cuisine ORDER BY total_revenue DESC;          -- Which cuisines generate the most revenue?--

SELECT AVG(order_amount) AS average_order_revenue FROM orders
WHERE order_status = 'Delivered';                                           -- average revenue per delivered order--


-- CUSTOMERS SPENDING ANALYSIS --

SELECT customer_id, SUM(order_amount) AS total_spending FROM orders WHERE order_status = 'Delivered' 
GROUP BY customer_id ORDER BY total_spending DESC;                         -- Which customers have the highest total spending?--

SELECT customer_id, COUNT(*) AS total_orders FROM orders
GROUP BY customer_id ORDER BY total_orders DESC;                              -- Which customers placed the most orders?--
 
SELECT customer_id, AVG(order_amount) AS average_spending FROM orders WHERE order_status = 'Delivered'
GROUP BY customer_id ORDER BY average_spending DESC;                          -- What is the average spending per customer?--

SELECT customer_id, COUNT(*) AS total_orders FROM orders
GROUP BY customer_id HAVING COUNT(*) = 1;                                      -- Which customers have placed only one order?--

SELECT customer_segment, SUM(order_amount) AS total_spending FROM customers_orders WHERE order_status = 'Delivered'
GROUP BY customer_segment ORDER BY total_spending DESC;                         -- Which customer segments generate the most spending?--

SELECT c.customer_segment,SUM(o.order_amount) AS total_spending FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered' GROUP BY c.customer_segment ORDER BY total_spending DESC;     -- Which customer segments generate the most spending?--

-- 
-- DELIVERY AND CANCELLATION ANALISIS--

SELECT order_id, delivery_minutes FROM orders WHERE order_status = 'Delivered'
ORDER BY delivery_minutes DESC LIMIT 10;                                     -- Which orders have the longest delivery times?--

SELECT order_id, delivery_minutes FROM orders WHERE order_status = 'Delivered'
ORDER BY delivery_minutes  LIMIT 10;                                         -- Which orders have the shortest delivery times?--   

SELECT COUNT(*) AS cancelled_orders FROM orders WHERE order_status = 'Cancelled';          -- How many orders were cancelled?--


-- PAYMENT ANALYSIS--

SELECT payment_method, COUNT(*) AS total_payments FROM payments 
GROUP BY payment_method ORDER BY total_payments DESC;                          -- Which payment methods are used most frequently?--

SELECT p.payment_method, SUM(o.order_amount) AS total_amount FROM payments p
JOIN orders o ON p.order_id = o.order_id WHERE o.order_status = 'Delivered'
GROUP BY p.payment_method ORDER BY total_amount DESC;                          -- Which payment methods generate the highest payment amount?--

SELECT payment_status, COUNT(*) AS total_payments FROM payments
GROUP BY payment_status ORDER BY total_payments DESC;                          -- How many payments were successful and failed?

SELECT payment_method, COUNT(*) AS failed_payments FROM payments WHERE payment_status = 'Failed'
GROUP BY payment_method ORDER BY failed_payments DESC;                          -- Which payment methods have the most failed payments?--


-- MENU AND PRICE ANALYSIS--

SELECT COUNT(*) AS total_menu_items FROM menu_items;                    -- total menu items--

SELECT restaurant_id, COUNT(*) AS total_menu_items FROM menu_items
GROUP BY restaurant_id ORDER BY total_menu_items DESC;                   -- Which restaurants have the most menu items?--

SELECT ROUND(AVG(price), 2) AS average_price FROM menu_items;             -- average price of menu items--

SELECT item_name, price FROM menu_items ORDER BY price DESC LIMIT 10;      -- items have the highest prices--

SELECT r.restaurant_name,ROUND(AVG(m.price), 2) AS average_price FROM restaurants r
INNER JOIN menu_items m ON r.restaurant_id = m.restaurant_id
GROUP BY r.restaurant_name ORDER BY average_price DESC;                   -- Which restaurants have the highest average menu prices?--


-- DISCOUNT ANALYSIS--

SELECT SUM(discount) AS total_discount FROM orders;                      -- total discount given--

SELECT order_id, discount FROM orders ORDER BY discount DESC LIMIT 10;      -- Which orders received the highest discounts--

SELECT order_id, discount FROM orders ORDER BY discount LIMIT 10;      -- Which orders received the least discounts--

SELECT ROUND(AVG(discount), 2) AS average_discount FROM orders;          -- What is the average discount per order?--

SELECT r.restaurant_name,SUM(o.discount) AS total_discount FROM restaurants r
INNER JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_name ORDER BY total_discount DESC;                  -- Which restaurants give the highest total discounts?--


-- MONTHLY REVENUE TRENDS ANALYSIS--

SELECT MONTH(order_date) AS month_number,SUM(order_amount) AS total_revenue FROM orders
WHERE order_status = 'Delivered' GROUP BY MONTH(order_date) ORDER BY month_number;      -- How does revenue change month by month?--

SELECT MONTH(order_date) AS month_number, SUM(order_amount) AS total_revenue FROM orders
WHERE order_status = 'Delivered' GROUP BY MONTH(order_date)
ORDER BY total_revenue DESC LIMIT 1;                                        -- Which month has the highest revenue?--

SELECT MONTH(order_date) AS month_number,SUM(order_amount) AS total_revenue FROM orders
WHERE order_status = 'Delivered' GROUP BY MONTH(order_date)
ORDER BY total_revenue ASC LIMIT 1;                                         -- Which month has the lowest revenue?--

