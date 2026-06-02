{{ config(materialized='table') }}

SELECT

    PRODUCT_ID,
    CUSTOMER_ID,
    ORDER_ID,
    CAST(AMOUNT AS NUMBER(10,2)) AS AMOUNT,
    PAYMENT_MODE,
    ORDER_TIME,
    DATE(ORDER_TIME) AS ORDER_DATE,
    STATUS,
    CUSTOMER_NAME,
    COUNTRY,
    AGE,
    GENDER,
    SIGNUP_DATE,
    PRODUCT_NAME,
    CATEGORY

FROM {{ source('pyspark_transformations', 'pyspark_transformated_orders') }}