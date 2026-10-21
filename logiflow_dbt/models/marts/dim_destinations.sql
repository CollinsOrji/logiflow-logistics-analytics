
with destinations as (

    select *
    from {{ ref('stg_destinations') }}

)

select
    destination_id,
    destination_name,
    region,
    created_at

from destinations
