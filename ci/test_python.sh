#!/bin/bash
cd $1
pip install -r requirements.txt
pytest --junitxml=test-results.xml --cov=. --cov-report=xml
