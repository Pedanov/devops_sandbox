#!/bin/bash

apk update
apk add nginx
rc-update add nginx default
