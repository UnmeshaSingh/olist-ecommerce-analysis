-- Olist E-Commerce Analysis: Database Schema
-- Creates the four tables used in this analysis.
-- Run in order: customers must exist before orders (foreign key dependency).

CREATE TABLE customers (
    customer_id            VARCHAR PRIMARY KEY,
    customer_unique_id     VARCHAR,
    customer_zip_code      VARCHAR,
    customer_city          VARCHAR,
    customer_state         VARCHAR
);

CREATE TABLE orders (
    order_id                       VARCHAR PRIMARY KEY,
    customer_id                    VARCHAR REFERENCES customers(customer_id),
    order_status                   VARCHAR,
    order_purchase_timestamp       TIMESTAMP,
    order_approved_at              TIMESTAMP,
    order_delivered_carrier_date   TIMESTAMP,
    order_delivered_customer_date  TIMESTAMP,
    order_estimated_delivery_date  TIMESTAMP
);

CREATE TABLE order_items (
    order_id            VARCHAR,
    order_item_id       INT,
    product_id          VARCHAR,
    seller_id           VARCHAR,
    shipping_limit_date TIMESTAMP,
    price               NUMERIC,
    freight_value       NUMERIC
);

CREATE TABLE order_payments (
    order_id             VARCHAR,
    payment_sequential   INT,
    payment_type         VARCHAR,
    payment_installments INT,
    payment_value        NUMERIC
);

-- Validation: confirm row counts after import
-- Expected: customers 99,441 | orders 99,441 | order_items 112,650 | order_payments 103,886
SELECT
  (SELECT COUNT(*) FROM customers)      AS customers,
  (SELECT COUNT(*) FROM orders)         AS orders,
  (SELECT COUNT(*) FROM order_items)    AS order_items,
  (SELECT COUNT(*) FROM order_payments) AS order_payments;
