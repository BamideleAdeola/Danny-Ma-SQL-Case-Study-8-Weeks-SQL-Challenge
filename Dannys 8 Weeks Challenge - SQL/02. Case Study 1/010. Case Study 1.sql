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
