#!/bin/bash
cd $1
pip install bandit
bandit -r .
