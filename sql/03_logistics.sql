-- Logistics Analysis
-- Question: How does delivery performance vary by region?
-- Finding: All states delivered early on average, but northern states (AL, MA, SE)
-- received ~2 days less buffer than São Paulo. Alagoas had a ~24% actual late rate.
-- Note: negative avg_delay_days = delivered earlier than estimated.

SELECT
    c.customer_state,
    COUNT(*) AS delivered_orders,
    ROUND(AVG(
        EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_estimated_delivery_date)) / 86400
    ), 2) AS avg_delay_days,
    SUM(CASE
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
        THEN 1 ELSE 0
    END) AS late_deliveries
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delay_days DESC;
