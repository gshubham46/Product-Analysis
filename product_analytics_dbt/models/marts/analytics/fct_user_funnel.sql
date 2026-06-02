with events as (

    select *
    from {{ ref('stg_events') }}

),

user_funnel as (

    select
        user_id,

        max(case when event_type = 'login' then 1 else 0 end) as did_login,
        max(case when event_type = 'view_home' then 1 else 0 end) as did_view_home,
        max(case when event_type = 'search' then 1 else 0 end) as did_search,
        max(case when event_type = 'view_content' then 1 else 0 end) as did_view_content,
        max(case when event_type = 'start_play' then 1 else 0 end) as did_start_play,
        max(case when event_type = 'stop_play' then 1 else 0 end) as did_stop_play

    from events
    group by user_id

)

select *
from user_funnel