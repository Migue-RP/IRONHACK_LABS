{{ config(materialized='table') }}

SELECT
    ORDER_DATE,
    ORDER_HOUR,
    COUNT(*) AS TOTAL_ORDERS,
    SUM(AMOUNT) AS HOURLY_GMV

FROM {{ ref('fct_orders') }}
WHERE STATUS = 'COMPLETED'
GROUP BY
    ORDER_DATE,
    ORDER_HOUR