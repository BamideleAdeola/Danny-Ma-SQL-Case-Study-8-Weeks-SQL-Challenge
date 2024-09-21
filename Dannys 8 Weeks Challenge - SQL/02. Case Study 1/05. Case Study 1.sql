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