with source as (

    select *
    from {{ source('logiflow', 'cancellation_reasons') }}

)

select
    cancellation_reason_id,
    reason,
    created_at

from source