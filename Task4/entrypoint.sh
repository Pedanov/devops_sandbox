#!/bin/sh

set -e

echo "DEVOPS=$DEVOPS"
sed -i "s/DEVOPS:/<h2>DEVOPS:$DEVOPS<h2>/" /home/www/index.html
nginx -g 'daemon off;'