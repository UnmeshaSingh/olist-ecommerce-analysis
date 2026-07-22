-- RFM Segmentation (Recency, Frequency, Monetary)
-- Question: Which customer segments drive value, and which are at risk?
-- Method: NTILE(4) window functions score each customer 1-4 on each dimension.
-- Recency is anchored to the latest purchase date in the dataset (data ends 2018).
-- Finding: 11,260 "At Risk" customers have the highest avg spend (R$272) but have
-- not purchased in ~500 days.
-- Caveat: ~97% of customers purchased only once, so frequency showed little variance;
-- segmentation is driven primarily by recency and monetary value.

WITH customer_metrics AS (
    SELECT
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp) AS last_purchase,
        COUNT(DISTINCT o.order_id)      AS frequency,
        SUM(p.payment_value)            AS monetary
    FROM orders o
    JOIN customers c      ON o.customer_id = c.customer_id
    JOIN order_payments p ON o.order_id    = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
reference AS (
    SELECT MAX(order_purchase_timestamp) AS max_date FROM orders
),
rfm_base AS (
    SELECT
        cm.customer_unique_id,
        EXTRACT(DAY FROM (r.max_date - cm.last_purchase)) AS recency_days,
        cm.frequency,
        cm.monetary
    FROM customer_metrics cm
    CROSS JOIN reference r
),
rfm_scored AS (
    SELECT
        customer_unique_id,
        recency_days,
        frequency,
        monetary,
        NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score,
        NTILE(4) OVER (ORDER BY frequency ASC)     AS f_score,
        NTILE(4) OVER (ORDER BY monetary ASC)      AS m_score
    FROM rfm_base
),
rfm_final AS (
    SELECT
        customer_unique_id, recency_days, frequency, monetary,
        r_score, f_score, m_score,
        CASE
            WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Champions'
            WHEN r_score >= 3 AND m_score >= 3                  THEN 'Loyal / High Value'
            WHEN r_score >= 3                                   THEN 'Recent / Promising'
            WHEN r_score = 1 AND m_score >= 3                   THEN 'At Risk (was valuable)'
            WHEN r_score = 1                                    THEN 'Lost / Dormant'
            ELSE 'Needs Attention'
        END AS segment
    FROM rfm_scored
)
SELECT
    segment,
    COUNT(*)                    AS num_customers,
    ROUND(AVG(monetary), 2)     AS avg_spend,
    ROUND(AVG(recency_days), 0) AS avg_recency_days
FROM rfm_final
GROUP BY segment
ORDER BY num_customers DESC;
