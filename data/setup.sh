#!/usr/bin/env bash

sudo apt install python3 install postgresql-client-common
pip install kaggle

# setup api token
cp kaggle.json ~/.kaggle
chmod 600 ~/.kaggle/kaggle.json
