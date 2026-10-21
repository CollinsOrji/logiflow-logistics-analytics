with cancelled as (
    select
        load_id,
        cancellation_reason_id,
        warehouse_id
    from {{ ref('fct_loads') }}
    where is_cancelled = 1
)
select
    c.cancellation_reason_id,
    r.reason as cancellation_reason,
    c.warehouse_id,
    w.warehouse_name,
    count(*) as cancelled_loads,
    round(
        100.0 * count(*) / nullif(sum(count(*)) over (), 0), 2
    ) as pct_of_all_cancellations
from cancelled c
left join {{ ref('dim_cancellation_reasons') }} r
    on c.cancellation_reason_id = r.cancellation_reason_id
left join {{ ref('dim_warehouses') }} w
    on c.warehouse_id = w.warehouse_id
group by
    c.cancellation_reason_id,
    r.reason,
    c.warehouse_id,
    w.warehouse_name
