select
    v.vehicle_id,
    v.vehicle_registration,
    v.vehicle_type,
    v.capacity,
    v.status as vehicle_status,
    count(l.load_id) as total_loads,
    count(*) filter (where l.is_delivered = 1) as delivered_loads,
    count(*) filter (where l.is_cancelled = 1) as cancelled_loads,
    count(*) filter (where l.is_on_time = 1) as on_time_deliveries,
    round(
        100.0 * count(*) filter (where l.is_on_time = 1)
        / nullif(count(*) filter (
            where l.is_delivered = 1
              and l.actual_delivery_datetime is not null
        ), 0), 2
    ) as on_time_delivery_rate_pct,
    round(avg(l.loading_duration_minutes)::numeric, 2)
        as avg_loading_duration_minutes
from {{ ref('dim_vehicles') }} v
left join {{ ref('fct_loads') }} l
    on v.vehicle_id = l.vehicle_id
group by
    v.vehicle_id,
    v.vehicle_registration,
    v.vehicle_type,
    v.capacity,
    v.status
