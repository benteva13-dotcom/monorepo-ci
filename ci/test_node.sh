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

echo "Running Node.js tests in: $SERVICE_PATH"
cd "$SERVICE_PATH"

# Check npm exists
if ! command -v npm >/dev/null 2>&1; then
  echo "Error: npm is not installed"
  exit 1
fi

echo "Installing dependencies..."
npm install --silent

echo "Running npm test..."
npm test -- --ci --reporters=jest-junit

echo "Node.js tests completed successfully!"
