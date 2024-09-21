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