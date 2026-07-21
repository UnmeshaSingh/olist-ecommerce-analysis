# Olist E-Commerce: Retention, Logistics & Customer Value Analysis

An end-to-end SQL analysis of 100,000+ real e-commerce transactions from the
Brazilian Olist dataset (2016–2018). The project investigates customer retention,
links regional logistics to customer value, and segments customers using RFM
analysis. Built with PostgreSQL, Google Sheets, and Looker Studio.

## 📊 Live Dashboard
[View the interactive dashboard here]([YOUR LOOKER LINK])

## Business Questions
1. What share of customers make a repeat purchase?
2. How does delivery performance vary by region?
3. Which regions and customer segments drive the most value?

## Dataset
- Source: [Olist Brazilian E-Commerce (Kaggle)](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- ~100k orders across 9 tables. This analysis uses: customers, orders, order_items, order_payments.
- Raw CSVs are not included in this repo; download them from the link above.

## Tools & Techniques
- **PostgreSQL** — CTEs, window functions (NTILE), date math, conditional aggregation (FILTER)
- **Google Sheets** — data staging and conditional-format heatmaps
- **Looker Studio** — interactive executive dashboard

## Data Quality Checks
Before analysis, the raw data was validated:
- Restricted analysis to `order_status = 'delivered'` to exclude cancelled/unavailable orders.
- Excluded orders with null delivery dates from logistics analysis.
- Verified the distinction between `customer_id` (per-order) and `customer_unique_id` (per-person).

## Key Findings

**1. Retention: a one-purchase business.**
Of 93,358 customers, only **3% made a repeat purchase** — 90,557 were one-time
buyers. The business is heavily acquisition-dependent, suggesting the highest-leverage
opportunity is post-purchase re-engagement rather than pure top-of-funnel spend.

**2. Logistics: consistent early delivery, but a regional gap.**
Olist beats its delivery estimates in every state, but the margin varies. Northern
states like Alagoas and Maranhão are delivered ~8 days early versus ~10+ days for
São Paulo — a consistent ~2-day regional gap. Alagoas also had a ~24% actual
late-delivery rate (95 of 397 orders), a risk hidden by the favorable average.

**3. Customer value: volume ≠ value.**
São Paulo drives the most revenue (R$5.77M) but has the *lowest* average customer
value (R$147). Smaller northern states — Ceará (R$212), Pernambuco (R$199),
Bahia (R$187) — generate 25–45% higher revenue per customer. The underserved
north contains higher-value customers, yet also receives the weakest delivery margins.

**4. RFM segmentation: high-value customers going cold.**
Segmenting customers by Recency, Frequency, and Monetary value surfaced 11,260
"At Risk" customers — the highest average spend of any segment (R$272) — who
haven't purchased in ~500 days. (Note: as ~97% of customers purchased only once,
frequency showed little variance, so segmentation was driven by recency and monetary value.)

## Business Recommendations
- **Invest in retention, not just acquisition** — a 3% repeat rate means small
  retention gains have outsized impact.
- **Launch a win-back campaign** targeting the 11,260 high-value dormant customers.
- **Audit logistics in high-value northern states** — the customers worth most are
  getting the weakest delivery performance.

## Repository Structure
- `/sql` — schema and all analysis queries
- `README.md` — this file

## Author
Unmesha Singh
