#!/bin/bash
SERVICE=$1

case $SERVICE in
  user-service)
    npm audit --audit-level=high
    ;;
  transaction-service)
    bandit -r .
    ;;
  notification-service)
    go vet ./...
    ;;
esac