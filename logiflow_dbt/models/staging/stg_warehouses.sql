with source as (

    select *
    from {{ source('logiflow', 'warehouses') }}

)

select
    warehouse_id,
    warehouse_name,
    location,
    created_at

from source