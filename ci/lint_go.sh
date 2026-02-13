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

echo "Running Go lint in: $SERVICE_PATH"
cd "$SERVICE_PATH"

# Run linter
if ! command -v golangci-lint >/dev/null 2>&1; then
  echo "Error: golangci-lint is not installed"
  exit 1
fi

golangci-lint run

echo "Go lint completed successfully!"
