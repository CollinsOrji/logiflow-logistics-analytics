with source as (

    select *
    from {{ source('logiflow', 'destinations') }}

)

select
    destination_id,
    destination_name,
    region,
    created_at

from source