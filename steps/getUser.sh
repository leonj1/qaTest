#!/bin/bash -x

QUERY=$1

TOKEN=`steps/login.sh ../credentials.txt`
URL=http://qa-takehome-dac9a438.dev.aetion.com:4440/user/search

# Search for the record
COUNT=`http -f POST $URL $QUERY X-Auth-Token:$TOKEN --body --json < /dev/tty`

if [ "$COUNT" == "0" ]; then
    exit 1
fi

exit 0
