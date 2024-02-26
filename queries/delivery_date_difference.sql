-- TODO: This query will return a table with two columns; State, and 
-- Delivery_Difference. The first one will have the letters that identify the 
-- states, and the second one the average difference between the estimate 
-- delivery date and the date when the items were actually delivered to the 
-- customer.
-- HINTS:
-- 1. You can use the julianday function to convert a date to a number.
-- 2. You can use the CAST function to convert a number to an integer.
-- 3. You can use the STRFTIME function to convert a order_delivered_customer_date to a string removing hours, minutes and seconds.
-- 4. order_status == 'delivered' AND order_delivered_customer_date IS NOT NULL

WITH MiCTE1 AS(
	SELECT 
		oo.customer_id, 
		JULIANDAY(DATE(oo.order_estimated_delivery_date)) - JULIANDAY(DATE(oo.order_delivered_customer_date)) AS Delivery_Difference
	FROM olist_orders oo
	WHERE oo.order_status = 'delivered'
	)
-- Calcula promedio de agrupa por diferencia  de fechas, ademas crea join con tabla de estados
SELECT 
	oc.customer_state AS State,
	CAST(AVG(ct.Delivery_Difference) AS INTEGER) AS Delivery_Difference
FROM MiCTE1 ct
LEFT JOIN olist_customers oc USING(customer_id)
GROUP BY oc.customer_state 
ORDER BY Delivery_Difference;
