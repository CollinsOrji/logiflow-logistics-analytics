with source as (

    select *
    from {{ source('logiflow', 'drivers') }}

)

select
    driver_id,
    driver_name,
    phone_number,
    created_at

from source