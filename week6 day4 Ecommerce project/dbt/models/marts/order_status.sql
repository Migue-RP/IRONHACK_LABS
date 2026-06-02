{{ config(materialized='table') }}

WITH order_status_summary AS (
    SELECT
        STATUS,
        COUNT(*) AS TOTAL_ORDERS
    FROM {{ ref('fct_orders') }}
    GROUP BY STATUS
)

SELECT
    STATUS,
    TOTAL_ORDERS,
    ROUND(100.0 * TOTAL_ORDERS/ SUM(TOTAL_ORDERS) OVER (),2) AS PERCENTAGE

FROM order_status_summary