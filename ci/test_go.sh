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

echo "Running Go tests in: $SERVICE_PATH"
cd "$SERVICE_PATH"

# Check Go exists
if ! command -v go >/dev/null 2>&1; then
  echo "Error: Go is not installed"
  exit 1
fi

echo "Running go test..."
go test ./... -v -coverprofile=coverage.out

echo "Go tests completed successfully!"
