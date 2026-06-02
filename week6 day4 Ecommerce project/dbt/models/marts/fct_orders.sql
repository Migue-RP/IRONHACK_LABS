{{ config(materialized='table') }}

SELECT
    ORDER_ID,
    CUSTOMER_ID,
    PRODUCT_ID,
    CUSTOMER_NAME,
    COUNTRY,
    AGE,
    GENDER,
    PRODUCT_NAME,
    CATEGORY,
    PAYMENT_MODE,
    STATUS,
    AMOUNT,
    ORDER_TIME,
    ORDER_DATE,
    SIGNUP_DATE,
    DATEDIFF(
        day,
        SIGNUP_DATE,
        ORDER_DATE
    ) AS CUSTOMER_TENURE_DAYS,
    EXTRACT(hour FROM ORDER_TIME) AS ORDER_HOUR
    
FROM {{ ref('stg_orders') }}