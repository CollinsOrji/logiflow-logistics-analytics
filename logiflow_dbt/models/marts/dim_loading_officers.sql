
with loading_officers as (

    select *
    from {{ ref('stg_loading_officers') }}

)

select
    officer_id,
    officer_name,
    warehouse_id,
    created_at

from loading_officers
