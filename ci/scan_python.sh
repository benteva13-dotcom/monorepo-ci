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

echo "Running Python security scan (bandit) in: $SERVICE_PATH"
cd "$SERVICE_PATH"

# Check pip exists
if ! command -v pip >/dev/null 2>&1; then
  echo "Error: pip is not installed"
  exit 1
fi

echo "Installing bandit..."
pip install --quiet bandit

echo "Running bandit..."
bandit -r .

echo "Python security scan completed successfully!"
