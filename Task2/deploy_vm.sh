#!/bin/bash

PROJ=DevOpsSandbox
set -e

# Check if keypair already exist
KEY=$(aws ec2 describe-key-pairs --key-name $PROJ)

# Create keypair
if [ -z "$KEY" ]
then
    aws ec2 create-key-pair --key-name $PROJ --query 'KeyMaterial' --output text > $PROJ.pem
    chmod 400 DevOpsSandbox.pem
fi

# Check if VM1 already exist
aws ec2 describe-instances --filters "Name=instance-type,Values=t2.micro" --query "Reservations[].Instances[].InstanceId"


# Create VM1
if [ -z "$VM1" ] then
    VM1=(aws ec2 run-instances \
    --image-id ami-0d527b8c289b4af7f \
    --count 1 \
    --instance-type t2.micro \
    --key-name $PROJ \
    --security-group-ids sg-0caa0b4472e1ccf68 \
    --subnet-id subnet-0581c55a9a2954854) \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=$PROJ-1}]')
fi

# Check if VM2 already exist

# Create VM2
if [ -z "$VM2" ] then
    VM1=(aws ec2 run-instances \
    --image-id ami-00e232b942edaf8f9 \
    --count 1 \
    --instance-type t2.micro \
    --key-name $PROJ \
    --security-group-ids sg-009394c54ec638427 \
    --subnet-id subnet-04478e78d3e91acaf \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=$PROJ-2}]')
fi

# Wait for instances to be deployed

# Install nginx

# Modify Welcome page

# Check ping
# To hosts
# Between hosts
