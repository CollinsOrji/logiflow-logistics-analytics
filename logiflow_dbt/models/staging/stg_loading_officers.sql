with source as (

    select *
    from {{ source('logiflow', 'loading_officers') }}

)

select
    officer_id,
    officer_name,
    warehouse_id,
    created_at

from source