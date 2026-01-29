#!/bin/bash

SERVICE_PATH=$1
IMAGE_NAME=$2
SHORT_SHA=$3

cd $SERVICE_PATH

docker build -t ${IMAGE_NAME}:ci-${SHORT_SHA} .
