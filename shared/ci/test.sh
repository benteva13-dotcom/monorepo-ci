#!/bin/bash
SERVICE=$1

case $SERVICE in
  user-service)
    npm test
    ;;
  transaction-service)
    pytest --junitxml=report.xml
    ;;
  notification-service)
    go test ./... -v
    ;;
esac