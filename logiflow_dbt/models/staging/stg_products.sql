with source as (

    select *
    from {{ source('logiflow', 'products') }}

)

select
    product_id,
    product_name,
    product_category,
    unit_of_measure,
    created_at

from source