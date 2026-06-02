with events as (

    select *
    from {{ ref('stg_events') }}

),

-- Step 1: get first activity per user
user_first_activity as (

    select
        user_id,
        min(event_time) as first_event_time
    from events
    group by user_id

),

-- Step 2: assign cohort week
user_cohorts as (

    select
        user_id,
        date_trunc('week', first_event_time) as cohort_week
    from user_first_activity

),

-- Step 3: join all events with cohort
user_activity as (

    select
        e.user_id,
        c.cohort_week,
        date_trunc('week', e.event_time) as activity_week
    from events e
    join user_cohorts c
        on e.user_id = c.user_id

),

-- Step 4: keep unique user-week activity
user_weekly_activity as (

    select distinct
        user_id,
        cohort_week,
        activity_week
    from user_activity

),

-- Step 5: calculate cohort sizes
cohort_sizes as (

    select
        cohort_week,
        count(distinct user_id) as cohort_users
    from user_weekly_activity
    group by cohort_week

),

-- Step 6: retention table
retention as (

    select
        u.cohort_week,
        u.activity_week,

        count(distinct u.user_id) as active_users,

        c.cohort_users,

        round(
            count(distinct u.user_id) * 100.0 / c.cohort_users,
            2
        ) as retention_rate

    from user_weekly_activity u
    join cohort_sizes c
        on u.cohort_week = c.cohort_week

    group by 1, 2, c.cohort_users

)

select *
from retention
order by cohort_week, activity_week