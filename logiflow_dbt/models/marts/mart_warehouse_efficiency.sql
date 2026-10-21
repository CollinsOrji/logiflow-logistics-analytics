select
    w.warehouse_id,
    w.warehouse_name,
    w.location as warehouse_location,
    count(l.load_id) as total_loads,
    count(*) filter (where l.is_delivered = 1) as delivered_loads,
    count(*) filter (where l.is_cancelled = 1) as cancelled_loads,
    round(
        100.0 * count(*) filter (where l.is_cancelled = 1)
        / nullif(count(l.load_id), 0), 2
    ) as cancellation_rate_pct,
    round(avg(l.loading_duration_minutes)::numeric, 2)
        as avg_loading_duration_minutes
from {{ ref('dim_warehouses') }} w
left join {{ ref('fct_loads') }} l
    on w.warehouse_id = l.warehouse_id
group by w.warehouse_id, w.warehouse_name, w.location
