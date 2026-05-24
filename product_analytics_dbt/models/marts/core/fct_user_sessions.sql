with events as (

    select *
    from {{ ref('stg_events') }}

),

sessionized as (

    select
        user_id,
        session_id,

        min(event_time) as session_start,
        max(event_time) as session_end,
        count(*) as total_events,

        extract(epoch from (max(event_time) - min(event_time))) as session_duration_seconds

    from events
    group by user_id, session_id

)

select
    user_id,
    session_id,
    session_start,
    session_end,
    total_events,
    session_duration_seconds

from sessionized