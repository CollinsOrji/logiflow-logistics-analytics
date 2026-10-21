with products as (

    select *
    from {{ ref('stg_products') }}

)

select
    product_id,
    product_name,
    product_category,
    unit_of_measure,
    created_at

from products