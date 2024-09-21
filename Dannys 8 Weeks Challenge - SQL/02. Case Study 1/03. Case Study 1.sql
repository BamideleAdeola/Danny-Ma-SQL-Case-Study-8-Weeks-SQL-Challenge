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