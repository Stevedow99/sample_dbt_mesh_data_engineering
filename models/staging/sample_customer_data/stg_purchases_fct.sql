{{
    config(
        materialized='table',
        schema='customer_data_example'
    )
}}

with source as (

    select * from {{ ref('purchases_fact_seed') }}

),final as (

    select
        id as transaction_id,
        customer_id,
        product_id,
        salesrep_id,
        amount as transaction_amount,
        purchase_datetime,
        created_timestamp,
        modified_timestamp
    from source

)

select * from final