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
),

sales_team AS (
    SELECT
        salesrep_id,
        salesrep_name,
        salesrep_start_date,
        is_trained_in_new_sales_program,
        salesrep_region,
        salesrep_email
    FROM {{ ref('stg_sales_team_dim') }}
)

SELECT
    p.transaction_id,
    p.customer_id,
    c.fname AS customer_first_name,
    c.lname AS customer_last_name,
    c.address AS customer_address,
    c.city AS customer_city,
    c.state AS customer_state,
    c.zip AS customer_zip,
    c.email AS customer_email,
    c.phone AS customer_phone,
    p.product_id,
    p.salesrep_id,
    s.salesrep_name,
    s.salesrep_start_date,
    s.is_trained_in_new_sales_program,
    s.salesrep_region,
    s.salesrep_email,
    p.transaction_amount

FROM purchases p

JOIN customers c
    ON p.customer_id = c.customer_id

JOIN sales_team s
    ON p.salesrep_id = s.salesrep_id
