USE danny;
GO

-- 2. How many days has each customer visited the restaurant?

SELECT 
	customer_id,
	COUNT(DISTINCT order_date) AS visitdays
FROM SALES 
GROUP BY customer_id;