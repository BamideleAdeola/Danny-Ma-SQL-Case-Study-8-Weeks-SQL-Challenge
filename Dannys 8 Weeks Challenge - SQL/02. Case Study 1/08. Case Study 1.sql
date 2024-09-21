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
