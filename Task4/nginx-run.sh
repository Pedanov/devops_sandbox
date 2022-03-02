#!/bin/bash

sudo docker run --env DEVOPS -d -p 80:80 my-nginx:0.1
# sudo docker run --env-file ./.env -d -p 80:80 my-nginx:0.1
