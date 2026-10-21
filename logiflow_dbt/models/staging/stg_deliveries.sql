with source as (

    select *
    from {{ source('logiflow', 'deliveries') }}

)

select
    delivery_id,
    load_id,
    actual_delivery_datetime,
    delivery_status,
    delivery_notes,
    created_at

from source