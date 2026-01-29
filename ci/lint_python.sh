#!/bin/bash
cd $1
pip install flake8
flake8 .
