/* Case Study 1: Danny's Diner

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
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
not just sushi - how many points do customer A and B have at the end of January?

*/
USE danny;
GO

-- Below are the SQL queries for each of the key questions.

----------------------------------------------------
/*QUE 1. What is the total amount each customer 
 spent at the restaurant?*/
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