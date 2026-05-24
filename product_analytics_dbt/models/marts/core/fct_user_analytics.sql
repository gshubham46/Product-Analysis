with sessions as (

    select *
    from {{ ref('fct_user_sessions') }}

),

user_aggregates as (

    select
        user_id,

        count(distinct session_id) as total_sessions,
        sum(total_events) as total_events,
        avg(total_events) as avg_events_per_session,

        sum(session_duration_seconds) as total_active_time_seconds,
        avg(session_duration_seconds) as avg_session_duration_seconds,

        max(session_end) as last_active_time,
        min(session_start) as first_active_time

    from sessions
    group by user_id

)

select *
from user_aggregates