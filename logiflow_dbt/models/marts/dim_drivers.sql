with drivers as (

    select *
    from {{ ref('stg_drivers') }}

)

select
    driver_id,
    driver_name,
    phone_number,
    created_at

from drivers