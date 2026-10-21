with vehicles as (

    select *
    from {{ ref('stg_vehicles') }}

)

select
    vehicle_id,
    vehicle_registration,
    vehicle_type,
    capacity,
    status,
    created_at

from vehicles