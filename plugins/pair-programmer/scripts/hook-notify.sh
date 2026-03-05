#!/bin/bash
# hook-notify.sh - Shared utility for all hooks to send overlay notifications
# Usage: hook-notify.sh "HookName" "details"

LOG="/tmp/videodb-hooks.log"

CONFIG_FILE="${HOME}/.config/videodb/config.json"
PORT=$(jq -r '.recorder_port // 8899' "$CONFIG_FILE" 2>/dev/null)

HOOK_NAME="$1"
DETAILS="$2"

if [ -z "$DETAILS" ]; then
  MSG="🪝 ${HOOK_NAME}"
else
  MSG="🪝 ${HOOK_NAME}\n${DETAILS}"
fi

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "http://127.0.0.1:${PORT}/api/overlay/show" \
  -H "Content-Type: application/json" \
  -d "$(jq -n --arg text "$MSG" '{text: $text}')" \
  2>/dev/null)

echo "$(date +%H:%M:%S) [${HOOK_NAME}] port=${PORT} http=${HTTP_CODE}" >> "$LOG"

exit 0
