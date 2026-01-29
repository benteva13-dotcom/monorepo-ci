#!/bin/bash

CHANGED=$(git diff --name-only HEAD~1 HEAD | cut -d'/' -f1 | sort -u)

echo "$CHANGED"
