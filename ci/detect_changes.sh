#!/bin/bash
set -euo pipefail

# Ensure we are inside a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: This script must be run inside a git repository"
  exit 1
fi

# Ensure there is at least one previous commit
if ! git rev-parse HEAD~1 >/dev/null 2>&1; then
  echo "Warning: No previous commit found. Treating as full change."
  echo "."
  exit 0
fi

# Detect changed top-level directories
CHANGED=$(git diff --name-only HEAD~1 HEAD | cut -d'/' -f1 | sort -u)

if [[ -z "$CHANGED" ]]; then
  echo "No changes detected"
  exit 0
fi

echo "$CHANGED"
