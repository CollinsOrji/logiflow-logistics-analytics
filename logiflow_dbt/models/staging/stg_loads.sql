with source as (

    select *
    from {{ source('logiflow', 'loads') }}

)

select
    load_id,
    customer_id,
    vehicle_id,
    driver_id,
    warehouse_id,
    destination_id,
    officer_id,
    loading_start_datetime,
    loading_end_datetime,
    expected_delivery_datetime,
    status,
    cancellation_reason_id,
    created_at

from source