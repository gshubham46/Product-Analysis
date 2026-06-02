import pandas as pd 
import random
from faker import Faker
from datetime import datetime, timedelta

faker = Faker()

NUM_USERS = 1000
MAX_SESSIONS_PER_USER = 5


# Master List of Possible Events
EVENTS = [
    "login",
    "view_home",
    "search",
    "view_content",
    "start_play",
    "pause",
    "resume",
    "stop_play",
    "add_to_watchlist",
    "logout"
]

data = []

# creating multiple sessions with their own timeline
for user_id in range(1, NUM_USERS + 1):
    num_sessions = random.randint(1, MAX_SESSIONS_PER_USER)

    for _ in range(num_sessions):
        session_id = faker.uuid4()
        session_start = faker.date_time_this_year()

        # Actual User Session Flow
        events_sequence = [
            "login",
            "view_home",
            "search", 
            "view_content",
            "start_play",
        ]

        if random.random() > 0.5:
            events_sequence.append("pause")
            events_sequence.append("resume")
        
        events_sequence.append("stop_play")

        if random.random() > 0.3:
            events_sequence.append("add_to_watchlist")
        
        if random.random() > 0.2:
            events_sequence.append("logout")

        current_time = session_start

        for event in events_sequence:
            data.append({
                "user_id": user_id,
                "session_id": session_id,
                "event_type": event,
                "content_id": random.randint(1, 500),  # Random content ID for view/search/play events
                "timestamp": current_time.isoformat()
            })
            # Increment time by a random amount between 1 and 5 minutes
            current_time += timedelta(minutes=random.randint(10, 300))
    
df = pd.DataFrame(data)
df.to_csv("data/raw/user_events.csv", index=False)

print("Data generated sucessfully!!")
print(df.head())



