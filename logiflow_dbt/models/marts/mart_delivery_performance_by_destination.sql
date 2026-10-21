with loads as (
    select * from {{ ref('fct_loads') }}
),
destinations as (
    select * from {{ ref('dim_destinations') }}
)
select
    d.destination_id,
    d.destination_name,
    d.region,
    count(l.load_id) as total_loads,
    count(*) filter (where l.is_delivered = 1) as delivered_loads,
    count(*) filter (where l.is_cancelled = 1) as cancelled_loads,
    count(*) filter (
        where l.is_delivered = 1
          and l.actual_delivery_datetime is not null
    ) as completed_deliveries,
    count(*) filter (where l.is_on_time = 1) as on_time_deliveries,
    round(
        100.0 * count(*) filter (where l.is_on_time = 1)
        / nullif(count(*) filter (
            where l.is_delivered = 1
              and l.actual_delivery_datetime is not null
        ), 0), 2
    ) as on_time_delivery_rate_pct,
    round(avg(l.delivery_delay_hours)::numeric, 2) as avg_delivery_delay_hours
from destinations d
left join loads l on d.destination_id = l.destination_id
group by d.destination_id, d.destination_name, d.region
