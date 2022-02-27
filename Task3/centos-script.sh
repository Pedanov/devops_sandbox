#!/bin/bash

systemctl enable nginx
systemctl start nginx
echo "Hello World" | tee /usr/share/nginx/html/index.html
echo "OS version:" | tee -a /usr/share/nginx/html/index.html
uname -a | tee -a /usr/share/nginx/html/index.html
