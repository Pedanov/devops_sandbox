#!/bin/bash

PROJ=DevOpsSandbox
set -e

# Check if VM1 exist

# Delete VM1
aws ec2 terminate-instances --instance-ids i-5203422c

# Check if VM2 exist

# Delete VM2

# Check if keypair exist

# Remove keypair
aws ec2 delete-key-pair --key-name $PROJ