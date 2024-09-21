/* Case Study 1: Danny's Diner

USE D
# Problem Statement

Danny opened a new restaurant and needs help 
analyzing the data to make better decisions. 
We need to answer questions related to 
customer behavior, sales, and trends. 

The data includes information on customers, 
sales transactions, and menu items.

### Data Model

The data consists of three main tables:

- **Customers**
- **Sales**
- **Menu**

--------------------
Case Study Questions
--------------------
-- 1. What is the total amount each customer spent at the restaurant?
-- 2. How many days has each customer visited the restaurant?
-- 3. What was the first item from the menu purchased by each customer?
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- 5. Which item was the most popular for each customer?
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
not just sushi - how many points do customer A and B have at the end of January?

*/
USE danny;
GO


SELECT * FROM sales;
GO
SELECT * FROM menu;
GO
SELECT * FROM members;
GO


-- Below are the SQL queries for each of the key questions.

----------------------------------------------------
/* QUE 1. 
What is the total amount each customer spent at the restaurant?*/
----------------------------------------------------

/* Solution
To calculate the Total Amount Spent by Each Customer: 
There is a need to join the sales, 
customers, and menu tables.*/

SELECT 
    s.customer_id, 
    SUM(m.price) AS total_spent
FROM dbo.sales s
JOIN dbo.menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;

---------------------------------------------------
/* QUE 2. 
How many days has each customer 
visited the restaurant? */

-- Naration:
-- This will be how many distinct days each customer 
-- or member visited the restaurant
---------------------------------------------------

SELECT 
	customer_id,
	COUNT(DISTINCT order_date) AS visitdays
FROM SALES 
GROUP BY customer_id;

-------------------------------------------------------
/* QUE 3. 
What was the first item from the menu purchased 
by each customer? */
-------------------------------------------------------
/*Narration:
This query retrieves the first item each customer purchased 
by finding the earliest order date.*/

SELECT 
	s.customer_id,
	m.product_name,
	s.order_date
FROM sales s
JOIN menu m ON m.product_id = s.product_id
WHERE s.order_date = (
		SELECT 
			MIN(order_date) 
		FROM sales
		WHERE customer_id = s.customer_id
	);

-- ALTERNATIVE APPROACH TO THE QUESTION USING CTE
-- COMMON TABLE EXPRESSION (CTE)
WITH firstOrder AS (
	SELECT customer_id,
	MIN(order_date) AS first_order_date
	FROM sales
	GROUP BY customer_id
)

SELECT 
	s.customer_id,
	m.product_name,
	s.order_date
FROM 
	sales s
JOIN firstOrder f ON f.customer_id = s.customer_id
AND f.first_order_date = s.order_date
JOIN menu m ON m.product_id = s.product_id;



-------------------------------------------------------
/*QUE 4. 
What is the most purchased item on the menu and how many times was it 
purchased by all customers?*/

/* Most Purchased Item: 
This query calculates the most purchased item across all customers by counting the number of 
times each product was purchased.*/
-------------------------------------------------------


SELECT TOP 1
	m.product_name,
	COUNT(s.product_id) AS total_purchase
FROM sales s
JOIN menu m ON m.product_id = s.product_id
GROUP BY m.product_name
ORDER BY COUNT(s.product_id) DESC;

-------------------------------------------------------
/* QUE 5. 
Which item was the most popular for each customer? */
-------------------------------------------------------

WITH customer_purchases AS 
(
	SELECT 
		s.customer_id,
		m.product_name,
		COUNT(s.product_id) AS purchase_count
	FROM sales s
	JOIN menu m ON m.product_id = s.product_id
	GROUP BY s.customer_id, m.product_name
)

SELECT 
	customer_id,
	product_name AS most_popular_item,
	purchase_count
FROM (
	SELECT 
		customer_id,
		product_name,
		purchase_count,
		ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY purchase_count DESC) AS rank
	FROM customer_purchases
) ranked_purchases
WHERE rank = 1;


---------------------------------------------------------------------------------
/* QUE 6. 
Which item was purchased first by the customer after they became a member? */
---------------------------------------------------------------------------------

WITH memberFirstPurchased AS (

	SELECT 
		s.customer_id,
		MIN(s.order_date) AS first_purchased_date
	FROM sales s
	JOIN members mb ON mb.customer_id = s.customer_id
	WHERE s.order_date >= mb.join_date
	GROUP BY s.customer_id
)

SELECT
	s.customer_id,
	m.product_name,
	s.order_date,
	ms.join_date
FROM sales s
JOIN menu m ON m.product_id = s.product_id
JOIN memberFirstPurchased mbp ON mbp.customer_id = s.customer_id AND mbp.first_purchased_date = s.order_date
JOIN members ms ON ms.customer_id = s.customer_id;

--------------------------------------------------------------------------
/* QUE 7. 
Which item was purchased just before the customer became a member? */
--------------------------------------------------------------------------
-- Step 1
WITH PreMembershipSales AS (
    SELECT 
        s.customer_id, 
        MAX(s.order_date) AS last_purchase_date
    FROM 
        sales s
    INNER JOIN 
        members m ON s.customer_id = m.customer_id
    WHERE 
        s.order_date < m.join_date
    GROUP BY 
        s.customer_id
)
SELECT  
 
    s.customer_id, 
    mu.product_name
FROM 
    sales s
INNER JOIN 
    PreMembershipSales pms ON s.customer_id = pms.customer_id AND s.order_date = pms.last_purchase_date
INNER JOIN 
    menu mu ON s.product_id = mu.product_id;


---------------------------------------------------------------------------------------------
/* QUE 8. 
What is the total items and amount spent for each member before they became a member? */
---------------------------------------------------------------------------------------------

SELECT * FROM sales;
GO
SELECT * FROM menu;
GO
SELECT * FROM members;
GO

/* 8. What is the total items and amount spent for 
each member before they became a member?*/
SELECT s.customer_id,
       Count(*)     AS total_items,
       Sum(m.price) AS total_amount
FROM   sales s
       JOIN menu m
         ON m.product_id = s.product_id
       JOIN members mb
         ON mb.customer_id = s.customer_id
WHERE  s.order_date < mb.join_date
GROUP  BY s.customer_id; 

----------------------------------------------------------------------
/* QUE 9. 
If each $1 spent equates to 10 points and sushi has 
a 2x points multiplier - how many points would each customer have?*/
----------------------------------------------------------------------
SELECT 
	s.customer_id,
	SUM(
		CASE 
			WHEN m.product_name = 'sushi' THEN m.price * 20
			ELSE m.price * 10
		END
	) AS totalPoints
FROM sales s
JOIN menu m ON m.product_id = s.product_id 
GROUP BY s.customer_id;


--------------------------------------------------------------------------------------
/* QUE 10:
In the first week after a customer joins the program 
(including their join date), they earn 2x points on all items. 
How many points do customer A and B have at the end of January? */
--------------------------------------------------------------------------------------
WITH points_cal AS 
(
	SELECT 
		s.customer_id,
		s.order_date,
		m.price,
		CASE 
			WHEN s.order_date BETWEEN mb.join_date AND DATEADD(DAY, 6, mb.join_date) THEN
				m.price * 20 -- 2x points
			ELSE
				m.price * 10   -- normal points
		END AS points
	FROM sales s
	JOIN members mb ON mb.customer_id = s.customer_id
	JOIN menu m ON m.product_id = s.product_id
	WHERE s.customer_id IN ('A', 'B')
	AND s.order_date <= '2021-01-31'
)

SELECT 
	customer_id,
	SUM(points) AS totalPoints
FROM points_cal
GROUP BY customer_id;

-- ALTERNATIVE APPROACH

WITH points_cal AS 
(
	SELECT 
		s.customer_id,
		--s.order_date,
		--m.price,
		SUM(CASE 
			WHEN s.order_date BETWEEN mb.join_date AND DATEADD(DAY, 6, mb.join_date) THEN
				m.price * 20 -- 2x points
			ELSE
				m.price * 10   -- normal points
		END) AS points
	FROM sales s
	JOIN members mb ON mb.customer_id = s.customer_id
	JOIN menu m ON m.product_id = s.product_id
	WHERE s.customer_id IN ('A', 'B')
	AND s.order_date <= '2021-01-31'
	GROUP BY s.customer_id
)

SELECT 
	customer_id,
	points AS totalPoints
FROM points_cal;


