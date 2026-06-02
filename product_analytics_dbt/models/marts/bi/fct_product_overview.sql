with sessions as (

    select * from {{ ref('fct_user_sessions') }}

),

users as (

    select * from {{ ref('fct_user_analytics') }}

),

session_metrics as (

    select
        count(distinct user_id) as total_users,
        count(distinct session_id) as total_sessions,
        avg(session_duration_seconds) as avg_session_duration,
        sum(total_events) as total_events
    from sessions

),

user_metrics as (

    select
        avg(total_sessions) as avg_sessions_per_user,
        avg(total_active_time_seconds) as avg_user_active_time
    from users

)

select
    s.total_users,
    s.total_sessions,
    s.avg_session_duration,
    s.total_events,
    u.avg_sessions_per_user,
    u.avg_user_active_time

from session_metrics s
cross join user_metrics u