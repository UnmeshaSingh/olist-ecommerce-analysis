-- Customer Lifetime Value by State
-- Question: Which regions drive the most revenue, and the most value per customer?
-- Finding: São Paulo leads total revenue (R$5.77M) but has the lowest avg CLV (R$147).
-- Northern states — Ceará (R$212), Pernambuco (R$199), Bahia (R$187) — show higher
-- per-customer value despite lower volume.

SELECT
    c.customer_state,
    COUNT(DISTINCT c.customer_unique_id) AS customers,
    ROUND(SUM(p.payment_value), 2) AS total_revenue,
    ROUND(SUM(p.payment_value) / COUNT(DISTINCT c.customer_unique_id), 2) AS avg_clv
FROM order_payments p
JOIN orders o ON p.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_revenue DESC;
