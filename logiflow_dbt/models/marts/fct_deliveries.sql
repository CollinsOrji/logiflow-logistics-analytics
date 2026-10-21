
with deliveries as (

    select *
    from {{ ref('stg_deliveries') }}

),

loads as (

    select
        load_id,
        customer_id,
        vehicle_id,
        driver_id,
        warehouse_id,
        destination_id,
        expected_delivery_datetime,
        status as load_status
    from {{ ref('stg_loads') }}

)

select
    d.delivery_id,
    d.load_id,

    l.customer_id,
    l.vehicle_id,
    l.driver_id,
    l.warehouse_id,
    l.destination_id,

    l.expected_delivery_datetime,
    d.actual_delivery_datetime,
    d.delivery_status,
    l.load_status,
    d.delivery_notes,
    d.created_at,

    case
        when d.actual_delivery_datetime is not null
             and l.expected_delivery_datetime is not null
        then extract(
            epoch from (
                d.actual_delivery_datetime
                - l.expected_delivery_datetime
            )
        ) / 3600.0
    end as delivery_delay_hours,

    case
        when d.actual_delivery_datetime is not null
             and l.expected_delivery_datetime is not null
             and d.actual_delivery_datetime
                 <= l.expected_delivery_datetime
        then 1
        else 0
    end as is_on_time

from deliveries d

left join loads l
    on d.load_id = l.load_id
