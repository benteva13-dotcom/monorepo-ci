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

echo "Running Python tests in: $SERVICE_PATH"
cd "$SERVICE_PATH"

# Check pip exists
if ! command -v pip >/dev/null 2>&1; then
  echo "Error: pip is not installed"
  exit 1
fi

echo "Installing pytest..."
pip install --quiet pytest

echo "Running pytest..."
pytest --junitxml=results.xml

echo "Python tests completed successfully!"
