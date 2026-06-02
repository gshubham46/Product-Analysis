select distinct
    event_type,

    case
        when event_type = 'login' then 1
        when event_type = 'view_home' then 2
        when event_type = 'search' then 3
        when event_type = 'view_content' then 4
        when event_type = 'start_play' then 5
        when event_type = 'pause' then 6
        when event_type = 'resume' then 7
        when event_type = 'stop_play' then 8
        when event_type = 'add_to_watchlist' then 9
        when event_type = 'logout' then 10
        else 99
    end as event_order

from {{ ref('stg_events') }}