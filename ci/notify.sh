ל#!/bin/bash
set -euo pipefail

# Validate input
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <webhook_url> <message>"
  exit 1
fi

WEBHOOK_URL=$1
MESSAGE=$2

# Validate webhook URL
if [[ -z "$WEBHOOK_URL" ]]; then
  echo "Error: Webhook URL is empty"
  exit 1
fi

# Validate message
if [[ -z "$MESSAGE" ]]; then
  echo "Error: Message is empty"
  exit 1
fi

# Check curl exists
if ! command -v curl >/dev/null 2>&1; then
  echo "Error: curl is not installed"
  exit 1
fi

echo "Sending notification..."
curl -X POST -H 'Content-type: application/json' \
    --data "{\"text\": \"${MESSAGE}\"}" \
    "$WEBHOOK_URL"

echo "Notification sent successfully!"
