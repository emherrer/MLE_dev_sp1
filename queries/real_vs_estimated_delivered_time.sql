-- TODO: This query will return a table with the differences between the real 
-- and estimated delivery times by month and year. It will have different 
-- columns: month_no, with the month numbers going from 01 to 12; month, with 
-- the 3 first letters of each month (e.g. Jan, Feb); Year2016_real_time, with 
-- the average delivery time per month of 2016 (NaN if it doesn't exist); 
-- Year2017_real_time, with the average delivery time per month of 2017 (NaN if 
-- it doesn't exist); Year2018_real_time, with the average delivery time per 
-- month of 2018 (NaN if it doesn't exist); Year2016_estimated_time, with the 
-- average estimated delivery time per month of 2016 (NaN if it doesn't exist); 
-- Year2017_estimated_time, with the average estimated delivery time per month 
-- of 2017 (NaN if it doesn't exist) and Year2018_estimated_time, with the 
-- average estimated delivery time per month of 2018 (NaN if it doesn't exist).
-- HINTS
-- 1. You can use the julianday function to convert a date to a number.
-- 2. order_status == 'delivered' AND order_delivered_customer_date IS NOT NULL
-- 3. Take distinct order_id.

SELECT 
	STRFTIME("%m", oo.order_purchase_timestamp) AS month_no,
	CASE STRFTIME("%m", oo.order_purchase_timestamp)
		WHEN '01' THEN 'JAN'
	    WHEN '02' THEN 'FEB'
	    WHEN '03' THEN 'MAR'
	    WHEN '04' THEN 'APR'
	    WHEN '05' THEN 'MAY'
	    WHEN '06' THEN 'JUN'
	    WHEN '07' THEN 'JUL'
	    WHEN '08' THEN 'AUG'
	    WHEN '09' THEN 'SEP'
	    WHEN '10' THEN 'OCT'
	    WHEN '11' THEN 'NOV'
	    WHEN '12' THEN 'DEC'
	END AS month,
	AVG(CASE WHEN STRFTIME('%Y', oo.order_purchase_timestamp) = '2016' THEN JULIANDAY(oo.order_delivered_customer_date)- JULIANDAY(oo.order_purchase_timestamp) ELSE NULL END) AS Year2016_real_time,
	AVG(CASE WHEN STRFTIME('%Y', oo.order_purchase_timestamp) = '2017' THEN JULIANDAY(oo.order_delivered_customer_date)- JULIANDAY(oo.order_purchase_timestamp) ELSE NULL END) AS Year2017_real_time,
	AVG(CASE WHEN STRFTIME('%Y', oo.order_purchase_timestamp) = '2018' THEN JULIANDAY(oo.order_delivered_customer_date)- JULIANDAY(oo.order_purchase_timestamp) ELSE NULL END) AS Year2018_real_time,
	AVG(CASE WHEN STRFTIME('%Y', oo.order_purchase_timestamp) = '2016' THEN JULIANDAY(oo.order_estimated_delivery_date)- JULIANDAY(oo.order_purchase_timestamp) ELSE NULL END) AS Year2016_estimated_time,
	AVG(CASE WHEN STRFTIME('%Y', oo.order_purchase_timestamp) = '2017' THEN JULIANDAY(oo.order_estimated_delivery_date)- JULIANDAY(oo.order_purchase_timestamp) ELSE NULL END) AS Year2017_estimated_time,
	AVG(CASE WHEN STRFTIME('%Y', oo.order_purchase_timestamp) = '2018' THEN JULIANDAY(oo.order_estimated_delivery_date)- JULIANDAY(oo.order_purchase_timestamp) ELSE NULL END) AS Year2018_estimated_time
FROM olist_orders oo
WHERE oo.order_status = 'delivered' AND oo.order_delivered_customer_date IS NOT NULL
GROUP BY month_no, month;