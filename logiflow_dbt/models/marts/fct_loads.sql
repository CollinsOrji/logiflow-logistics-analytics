with loads as (

    select *
    from {{ ref('stg_loads') }}

),

deliveries as (

    select
        load_id,
        actual_delivery_datetime,
        delivery_status
    from {{ ref('stg_deliveries') }}

)

select
    l.load_id,
    l.customer_id,
    l.vehicle_id,
    l.driver_id,
    l.warehouse_id,
    l.destination_id,
    l.officer_id,
    l.loading_start_datetime,
    l.loading_end_datetime,
    l.expected_delivery_datetime,
    l.status,
    l.cancellation_reason_id,
    l.created_at,

    -- Loading duration
    extract(
        epoch from (
            l.loading_end_datetime - l.loading_start_datetime
        )
    ) / 60.0 as loading_duration_minutes,

    -- Delivery information
    d.actual_delivery_datetime,
    d.delivery_status,

    -- Delivery delay
    case
        when d.actual_delivery_datetime is not null
             and l.expected_delivery_datetime is not null
        then extract(
            epoch from (
                d.actual_delivery_datetime - l.expected_delivery_datetime
            )
        ) / 3600.0
    end as delivery_delay_hours,

    -- Business flags
    case
        when l.status = 'Delivered' then 1
        else 0
    end as is_delivered,

    case
        when l.status = 'Cancelled' then 1
        else 0
    end as is_cancelled,

    case
        when d.actual_delivery_datetime is not null
             and l.expected_delivery_datetime is not null
             and d.actual_delivery_datetime <= l.expected_delivery_datetime
        then 1
        else 0
    end as is_on_time

from loads l

left join deliveries d
    on l.load_id = d.load_id