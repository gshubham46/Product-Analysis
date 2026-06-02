select
    user_id,
    session_id,
    event_type,
    content_id,
    timestamp::timestamp as event_time
from {{ source('raw', 'raw_events') }}