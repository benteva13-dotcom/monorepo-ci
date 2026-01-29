#!/bin/bash
cd $1
go test ./... -v -coverprofile=coverage.out
