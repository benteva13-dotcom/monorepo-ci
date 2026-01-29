#!/bin/bash
cd $1
npm install
npm test -- --ci --reporters=jest-junit
