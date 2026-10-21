with load_items as (

    select *
    from {{ ref('stg_load_items') }}

)

select
    load_item_id,
    load_id,
    product_id,
    quantity,
    created_at

from load_items