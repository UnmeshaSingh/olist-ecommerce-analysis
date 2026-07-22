-- Retention Analysis
-- Question: What share of customers make a repeat purchase?
-- Finding: Only 3% of customers purchased more than once (2,801 of 93,358).

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE order_count = 1) AS one_time_buyers,
    COUNT(*) FILTER (WHERE order_count > 1) AS repeat_buyers,
    ROUND(100.0 * COUNT(*) FILTER (WHERE order_count > 1) / COUNT(*), 2) AS repeat_rate_pct
FROM customer_orders;


-- Supporting analysis: monthly cohort retention matrix
-- Tracks how many customers from each acquisition month return in later months.

WITH first_purchase AS (
    SELECT
        c.customer_unique_id,
        DATE_TRUNC('month', MIN(o.order_purchase_timestamp)) AS cohort_month
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
all_purchases AS (
    SELECT
        c.customer_unique_id,
        DATE_TRUNC('month', o.order_purchase_timestamp) AS purchase_month
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),
cohort_data AS (
    SELECT
        fp.cohort_month,
        ap.customer_unique_id,
        (EXTRACT(YEAR FROM ap.purchase_month) - EXTRACT(YEAR FROM fp.cohort_month)) * 12
          + (EXTRACT(MONTH FROM ap.purchase_month) - EXTRACT(MONTH FROM fp.cohort_month)) AS month_number
    FROM first_purchase fp
    JOIN all_purchases ap ON fp.customer_unique_id = ap.customer_unique_id
),
cohort_counts AS (
    SELECT cohort_month, month_number,
           COUNT(DISTINCT customer_unique_id) AS active_customers
    FROM cohort_data
    GROUP BY cohort_month, month_number
),
cohort_size AS (
    SELECT cohort_month, active_customers AS total_customers
    FROM cohort_counts
    WHERE month_number = 0
)
SELECT
    cc.cohort_month,
    cc.month_number,
    cc.active_customers,
    cs.total_customers,
    ROUND(100.0 * cc.active_customers / cs.total_customers, 2) AS retention_pct
FROM cohort_counts cc
JOIN cohort_size cs ON cc.cohort_month = cs.cohort_month
ORDER BY cc.cohort_month, cc.month_number;
