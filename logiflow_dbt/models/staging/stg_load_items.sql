with source as (

    select *
    from {{ source('logiflow', 'load_items') }}

)

select
    load_item_id,
    load_id,
    product_id,
    quantity,
    created_at

from source