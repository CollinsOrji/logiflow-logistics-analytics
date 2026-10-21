with source as (

    select *
    from {{ source('logiflow', 'customers') }}

)

select
    customer_id,
    customer_name,
    customer_type,
    created_at

from source