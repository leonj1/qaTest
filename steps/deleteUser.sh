#!/bin/bash

QUERY=$1
DATA=`cat $2`
TOKEN=`steps/login.sh ../credentials.txt`
URL=http://localhost:3000/comments

# Search for the record
ID=`http GET "$URL?q=$QUERY" --body < /dev/tty | jq '.[] | .id'`

if [ "$ID" == "" ]; then
    exit 1
fi

# Update record
# TODO Bug exists in scenario where user does not exist before editing returns true today
OUTPUT=`http PUT $URL/$ID X-Auth-Token=$TOKEN "$DATA" --body < /dev/tty`

# Verify record with old query no longer exists
VERIFICATION=`http GET "$URL?q=$QUERY" --body < /dev/tty | jq 'length'`

if [ "$VERIFICATION" == 0 ]; then
    # record was successfully changed
    exit 0
fi

# record was not updated as expected
exit 1

