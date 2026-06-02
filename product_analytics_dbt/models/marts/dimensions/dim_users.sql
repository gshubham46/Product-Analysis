with base as (

    select *
    from {{ ref('stg_events') }}

),

user_stats as (

    select
        user_id,
        min(event_time) as first_seen,
        max(event_time) as last_seen,
        count(*) as total_events
    from base
    group by user_id

)

select
    user_id,
    first_seen,
    last_seen,
    total_events
from user_stats