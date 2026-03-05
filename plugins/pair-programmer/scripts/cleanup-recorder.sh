#!/bin/bash
# cleanup-recorder.sh - SessionEnd hook to stop recorder when session ends
# Only runs when reason is prompt_input_exit (e.g. one-off claude -c -p). Skips
# other/logout/clear so interactive session exits don't stop the recorder.

INPUT=$(cat)
LOG="/tmp/session-end.log"
REASON=$(echo "$INPUT" | jq -r '.reason // ""' 2>/dev/null)
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) reason=$REASON" >> "$LOG"
echo "$INPUT" | jq -c . >> "$LOG" 2>/dev/null || echo "$INPUT" >> "$LOG"

case "$REASON" in
  prompt_input_exit) ;;
  *) exit 0 ;;
esac

CONFIG_DIR="${HOME}/.config/videodb"
CONFIG_FILE="${CONFIG_DIR}/config.json"

# Read port from config (default 8899)
PORT=$(jq -r '.recorder_port // 8899' "$CONFIG_FILE" 2>/dev/null)

# Step 1: Request graceful shutdown via API
SHUTDOWN_RESP=$(curl -s -o /dev/null -w "%{http_code}" -X POST "http://127.0.0.1:${PORT}/api/shutdown" -H "Content-Type: application/json" 2>/dev/null)
if [ "$SHUTDOWN_RESP" = "200" ]; then
  echo "Graceful shutdown requested (port: $PORT)" >&2
else
  echo "Shutdown endpoint failed (HTTP $SHUTDOWN_RESP), will force-kill" >&2
fi

# Step 2: Wait 15s for graceful shutdown, then force-kill anything still on the port
(
  sleep 2
  PID=$(lsof -ti :$PORT 2>/dev/null)
  if [ -n "$PID" ]; then
    kill -9 $PID 2>/dev/null
    echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) Force-killed PID $PID on port $PORT" >> "$LOG"
  fi
) &

exit 0
