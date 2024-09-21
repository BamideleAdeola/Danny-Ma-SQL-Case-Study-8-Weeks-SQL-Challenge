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