#!/bin/bash

apt update -y
apt -y install ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt -y update
apt -y install docker-ce docker-ce-cli containerd.io
apt -y install nginx
systemctl enable nginx
systemctl start nginx

echo "Hello World" | tee /var/www/html/index.nginx-debian.html
echo "OS version:" | tee -a /var/www/html/index.nginx-debian.html
uname -a | tee -a /var/www/html/index.nginx-debian.html
