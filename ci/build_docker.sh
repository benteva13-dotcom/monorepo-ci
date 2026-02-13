#!/bin/bash
set -euo pipefail

# Validate input
if [[ $# -ne 3 ]]; then
  echo "Usage: $0 <service_path> <image_name> <short_sha>"
  exit 1
fi

SERVICE_PATH=$1
IMAGE_NAME=$2
SHORT_SHA=$3

# Check directory exists
if [[ ! -d "$SERVICE_PATH" ]]; then
  echo "Error: Service path '$SERVICE_PATH' does not exist"
  exit 1
fi

echo "Building Docker image for service: $SERVICE_PATH"
cd "$SERVICE_PATH"

# Check docker exists
if ! command -v docker >/dev/null 2>&1; then
  echo "Error: Docker is not installed"
  exit 1
fi

echo "Running: docker build -t ${IMAGE_NAME}:ci-${SHORT_SHA} ."
docker build -t "${IMAGE_NAME}:ci-${SHORT_SHA}" .

echo "Docker image built successfully!"
