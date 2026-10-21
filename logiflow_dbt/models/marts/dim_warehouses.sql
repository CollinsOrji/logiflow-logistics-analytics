
with warehouses as (

    select *
    from {{ ref('stg_warehouses') }}

)

select
    warehouse_id,
    warehouse_name,
    location,
    created_at

from warehouses
