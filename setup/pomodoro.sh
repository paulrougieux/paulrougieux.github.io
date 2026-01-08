#!/bin/bash
# Pomodoro tracker script
# Appends current date, time, and duration to a log file

LOG_FILE="$HOME/rp/bookmarkdown/work/pomodori/pomodori_log.txt"

# Get duration from command line argument
DURATION=$1
DESCRIPTION=$2

# Validate duration
if [[ "$DURATION" != "25" && "$DURATION" != "50" ]]; then
    echo "Usage: pom [25|50]"
    echo "  25 - for 25 minute pomodoro"
    echo "  50 - for 50 minute pomodoro"
    exit 1
fi

# Get current date and time
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Append to log file
echo "$TIMESTAMP, $DURATION minutes, $DESCRIPTION" >> "$LOG_FILE"

# Display confirmation
echo "$TIMESTAMP, $DURATION minutes, $DESCRIPTION"
