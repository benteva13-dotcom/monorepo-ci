#!/bin/bash
cd $1
npm install
npm audit --audit-level=high
