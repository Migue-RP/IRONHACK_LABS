{{ config(materialized='table') }}

SELECT
    PRODUCT_NAME,
    CATEGORY,
    COUNT(*) AS ORDERS_COUNT,
    SUM(AMOUNT) AS REVENUE

FROM {{ ref('fct_orders') }}
WHERE STATUS = 'COMPLETED'
GROUP BY
    PRODUCT_NAME,
    CATEGORY
ORDER BY REVENUE DESC