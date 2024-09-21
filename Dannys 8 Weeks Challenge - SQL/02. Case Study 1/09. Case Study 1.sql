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
