#!/bin/bash

apt update -y && apt install -y ansible python3-pip
ansible-galaxy collection install amazon.aws
pip install boto3
