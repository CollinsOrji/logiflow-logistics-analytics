with source as (
    select *
    from {{ source('logiflow', 'vehicles') }}
)

select
    vehicle_id,
    vehicle_registration,
    vehicle_type,
    capacity,
    status,
    created_at
from source