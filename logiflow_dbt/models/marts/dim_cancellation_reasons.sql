
with cancellation_reasons as (
    select *
    from {{ ref('stg_cancellation_reasons') }}
)
select
    cancellation_reason_id,
    reason,
    created_at
from cancellation_reasons