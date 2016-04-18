#!/bin/bash

TOKEN=`steps/login.sh`
URL=http://qa-takehome-dac9a438.dev.aetion.com:4440/user
DATA=`cat $1`

OUTPUT=`http -f POST $URL X-Auth-Token:$TOKEN $DATA --json < /dev/tty`
#OUTPUT=`curl -H "X-Auth-Token: $TOKEN" -d "$DATA" -X POST $URL`

ID=`echo $OUTPUT | jq '.id'`

# Validating the user account is getting created
if [ "$ID" -gt 0 ]; then
    echo "User Created!"
else
    echo "User Not Created"
fi

echo "$OUTPUT"

