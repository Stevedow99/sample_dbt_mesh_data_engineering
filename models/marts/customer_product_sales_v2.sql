{{
    config(
        materialized='table',
        schema='customer_data_example'
    )
}}

WITH purchases AS (
    SELECT
        transaction_id,
        customer_id,
        product_id,
        salesrep_id,
        transaction_amount,
        purchase_datetime
    FROM {{ ref('stg_purchases_fct') }}
),

products AS (
    SELECT
        product_id,
        vehicle_name,
        vehicle_category,
        vehicle_color,
        vehicle_weight,
        vehicle_dimensions
    FROM {{ ref('stg_product_dim') }}
),

customers AS (
    SELECT
        customer_id,
        gender,
        birthdate,
        maiden_name,
        lname,
        fname,
        address,
        city,
        state,
        zip,
        phone,
        email,
        cc_type,
        cc_number,
        cc_cvc,
        customer_join_date
    FROM {{ ref('stg_customers_dim') }}
)

SELECT
    p.transaction_id,
    p.customer_id,
    c.fname,
    c.lname,
    c.address,
    c.city,
    c.state,
    c.zip,
    c.email,
    c.phone,
    p.product_id,
    pr.vehicle_name,
    pr.vehicle_category,
    pr.vehicle_color,
    pr.vehicle_weight,
    pr.vehicle_dimensions,
    p.salesrep_id,
    p.transaction_amount--,
    --p.purchase_datetime

FROM purchases p

JOIN products pr
    ON p.product_id = pr.product_id

JOIN customers c
    ON p.customer_id = c.customer_id
