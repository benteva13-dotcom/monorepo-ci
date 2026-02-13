#!/bin/bash
set -euo pipefail

# Validate input
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <service_path>"
  exit 1
fi

SERVICE_PATH=$1

# Check directory exists
if [[ ! -d "$SERVICE_PATH" ]]; then
  echo "Error: Service path '$SERVICE_PATH' does not exist"
  exit 1
fi

echo "Running secret scan (gitleaks) in: $SERVICE_PATH"
cd "$SERVICE_PATH"

# Check gitleaks exists
if ! command -v gitleaks >/dev/null 2>&1; then
  echo "Error: gitleaks is not installed"
  exit 1
fi

echo "Running gitleaks..."
gitleaks detect --source . --no-banner

echo "Secret scan completed successfully!"
