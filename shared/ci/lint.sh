#!/bin/bash
SERVICE=$1

case $SERVICE in
  user-service)
    npm install
    npx eslint .
    ;;
  transaction-service)
    pip install flake8
    flake8 .
    ;;
  notification-service)
    golangci-lint run
    ;;
esac