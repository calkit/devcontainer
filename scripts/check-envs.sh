#!/usr/bin/env bash

CMD="calkit check envs"
CACHE_DIR="$HOME/.cache"
mkdir -p "$CACHE_DIR"
LOGFILE="$CACHE_DIR/check-envs.log"

echo "Starting env check at $(date)" > "$LOGFILE"

# Test Docker daemon accessibility first
MAX_WAIT=60
COUNT=0
until docker info >> "$LOGFILE" 2>&1; do
    COUNT=$((COUNT+1))
    if [ "$COUNT" -ge "$MAX_WAIT" ]; then
        echo "ERROR: Docker daemon not accessible after ${MAX_WAIT}s" >> "$LOGFILE"
        exit 1
    fi
    echo "Waiting for Docker daemon... (${COUNT}s)" >> "$LOGFILE"
    sleep 1
done

# Run docker pull in background with progress tracking
# Prefer setsid to fully detach; fallback to nohup if setsid is unavailable
if command -v setsid >/dev/null 2>&1; then
    setsid bash -c "
        echo \"Check started at \$(date)\" >> \"$LOGFILE\"
        $CMD >> \"$LOGFILE\" 2>&1
        EXIT_CODE=\$?
        echo \"Check completed at \$(date) with exit code: \$EXIT_CODE\" >> \"$LOGFILE\"
    " > /dev/null 2>&1 < /dev/null &
else
    nohup bash -c "
        echo \"Check started at \$(date)\" >> \"$LOGFILE\"
        $CMD >> \"$LOGFILE\" 2>&1
        EXIT_CODE=\$?
        echo \"Check completed at \$(date) with exit code: \$EXIT_CODE\" >> \"$LOGFILE\"
    " > /dev/null 2>&1 < /dev/null &
fi

PULL_PID=$!
echo "Env check started in background (PID: $PULL_PID)" >> "$LOGFILE"

# Briefly verify the background process hasn't already exited
sleep 0.2
if ! ps -p "$PULL_PID" > /dev/null 2>&1; then
    echo "WARNING: Background check process ($PULL_PID) exited early. Check logs above for errors." >> "$LOGFILE"
fi
