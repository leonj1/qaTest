#!/bin/bash -x

EMAIL=$1
DATA="$2"
TOKEN=`steps/login.sh`
URL=http://qa-takehome-dac9a438.dev.aetion.com:4440

echo Here
ALLRECORDS=`http -f POST $URL/user/search X-Auth-Token:$TOKEN start_age=1 end_age=100 --json < /dev/tty`
echo $ALLRECORDS
ALLOBJECTS=`echo $ALLRECORDS | jq '.[]'`
echo $ALLOBJECTS
FOREMAIL=`echo $ALLOBJECTS | jq 'select(contains({"email":"$EMAIL"}))'`
echo $FOREMAIL
echo Output above

# Search for the record
# Since we can only search using age then lets cast a wide net to catch as many accounts as possible first
for x in `http -f POST $URL/user/search X-Auth-Token:$TOKEN start_age=1 end_age=100 --json < /dev/tty | jq '.[] | select(contains({"email": "$EMAIL"})) | .id'`; do
    echo "Making an update to record id $x"
    http PUT $URL/user/$x $DATA --json --body < /dev/tty
done

