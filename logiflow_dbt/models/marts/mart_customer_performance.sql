with customer_loads as (
    select
        customer_id,
        count(*) as total_loads,
        count(*) filter (where is_delivered = 1) as delivered_loads,
        count(*) filter (where is_cancelled = 1) as cancelled_loads,
        count(*) filter (where is_on_time = 1) as on_time_deliveries,
        count(*) filter (
            where is_delivered = 1
              and actual_delivery_datetime is not null
        ) as completed_deliveries,
        round(avg(loading_duration_minutes)::numeric, 2)
            as avg_loading_duration_minutes
    from {{ ref('fct_loads') }}
    group by customer_id
)
select
    c.customer_id,
    c.customer_name,
    c.customer_type,
    coalesce(cl.total_loads, 0) as total_loads,
    coalesce(cl.delivered_loads, 0) as delivered_loads,
    coalesce(cl.cancelled_loads, 0) as cancelled_loads,
    round(
        100.0 * coalesce(cl.cancelled_loads, 0)
        / nullif(cl.total_loads, 0), 2
    ) as cancellation_rate_pct,
    round(
        100.0 * coalesce(cl.on_time_deliveries, 0)
        / nullif(cl.completed_deliveries, 0), 2
    ) as on_time_delivery_rate_pct,
    cl.avg_loading_duration_minutes
from {{ ref('dim_customers') }} c
left join customer_loads cl on c.customer_id = cl.customer_id
