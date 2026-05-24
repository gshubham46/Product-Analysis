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

), funnel_counts as (

    select

        count(*) as total_users,

        sum(did_login) as login_users,
        sum(did_view_home) as home_users,
        sum(did_search) as search_users,
        sum(did_view_content) as content_users,
        sum(did_start_play) as start_play_users,
        sum(did_stop_play) as stop_play_users

    from user_funnel

)

select

    total_users,

    login_users,
    home_users,
    search_users,
    content_users,
    start_play_users,
    stop_play_users,

    round(home_users * 100.0 / login_users, 2) as login_to_home_pct,
    round(search_users * 100.0 / home_users, 2) as home_to_search_pct,
    round(content_users * 100.0 / search_users, 2) as search_to_content_pct,
    round(start_play_users * 100.0 / content_users, 2) as content_to_play_pct,
    round(stop_play_users * 100.0 / start_play_users, 2) as play_to_complete_pct

from funnel_counts