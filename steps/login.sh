#!/bin/bash

# login and get the generated token
TOKEN=`http -f POST http://qa-takehome-dac9a438.dev.aetion.com:4440/login Content-Type:application/json "username"="admin" "password"="HG9Twy4LkPtoowdpyKnc" --json --body < /dev/tty | jq '.token' | sed -e 's/^"//'  -e 's/"$//'`

echo "$TOKEN"
