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