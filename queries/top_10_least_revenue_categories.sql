-- TODO: This query will return a table with the top 10 least revenue categories 
-- in English, the number of orders and their total revenue. The first column 
-- will be Category, that will contain the top 10 least revenue categories; the 
-- second one will be Num_order, with the total amount of orders of each 
-- category; and the last one will be Revenue, with the total revenue of each 
-- catgory.
-- HINT: All orders should have a delivered status and the Category and actual 
-- delivery date should be not null.

WITH cte1 AS 
(SELECT 
	SUM(oop.payment_value) AS Revenue,
	COUNT(DISTINCT oop.order_id) AS Num_order,
	op.product_category_name
FROM olist_order_payments oop 
LEFT JOIN olist_orders oo USING(order_id)
LEFT JOIN olist_order_items ooi USING(order_id)
LEFT JOIN olist_products op USING(product_id)
WHERE oo.order_status = 'delivered' AND oo.order_delivered_customer_date IS NOT NULL AND op.product_category_name IS NOT NULL
GROUP BY (op.product_category_name)
)

SELECT
	pcnt.product_category_name_english AS Category,
	cte1.Num_order,
	cte1.Revenue
FROM product_category_name_translation pcnt 
LEFT JOIN cte1 USING(product_category_name)
ORDER BY cte1.Revenue
LIMIT 10;