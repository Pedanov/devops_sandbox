#!/bin/bash

amazon-linux-extras enable nginx1
yum update -y
yum -y install nginx jq
systemctl enable nginx
systemctl start nginx

# echo "<!DOCTYPE HTML>" | tee /usr/share/nginx/html/index.html
echo "Hello World" | tee -a /usr/share/nginx/html/index.html
echo "OS version:" | tee -a /usr/share/nginx/html/index.html
uname -a | tee -a /usr/share/nginx/html/index.html
echo "Free disl space" | tee -a /usr/share/nginx/html/index.html
df -lH | tee -a /usr/share/nginx/html/index.html
echo "Free disl space" | tee -a /usr/share/nginx/html/index.html
free -m | tee -a /usr/share/nginx/html/index.html
echo "Running processes" | tee -a /usr/share/nginx/html/index.html
ps -aux | jq -sR '[sub("\n$";"") | splits("\n") | sub("^ +";"") | [splits(" +")]] | .[0] as $header | .[1:] | [.[] | [. as $x | range($header | length) | {"key": $header[.], "value": $x[.]}] | from_entries]' | tee -a /usr/share/nginx/html/index.html
