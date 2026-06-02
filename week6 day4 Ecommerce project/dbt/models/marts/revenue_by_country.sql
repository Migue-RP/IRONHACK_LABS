{{ config(materialized='table') }}

SELECT
    COUNTRY,
    COUNT(*) AS TOTAL_ORDERS,
    SUM(AMOUNT) AS TOTAL_REVENUE,
    AVG(AMOUNT) AS AVG_ORDER_VALUE

FROM {{ ref('fct_orders') }}
WHERE STATUS = 'COMPLETED'
GROUP BY COUNTRY