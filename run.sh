#!/bin/bash

TMPFILE=/tmp/tmpfile.txt
OUTPUT=results.txt
rm -f $OUTPUT

export PREV_COMPONENT=
export PREV_SEVERITY=
export PREV_TESTTYPE=
export PREV_RESULT=

PREV_COMPONENT_COUNT=0
TEST_RESULT=

while IFS=, read aa bb cc dd ee ff gg hh;do
    # get the first char to determine if its a comment that must be skipped
    firstChar=${aa:0:1}
    if [ "$firstChar" != "#" ]; then
        if [ "$aa" != "" ]; then
            TESTTYPE=$aa
            COMPONENT=$bb
            SCRIPT=$cc
            SEVERITY=$dd
            CHECK_TYPE=$ee
            EXPECTED=$ff
            DATA=$gg
            ID=$hh
            #echo $TESTTYPE $COMPONENT $SCRIPT $SEVERITY $EXPECTED $CHECK_TYPE $DATA $ID

            if [ "$PREV_COMPONENT" != "" ] && [ "$PREV_COMPONENT" != "$COMPONENT" ]; then
                echo "['$PREV_COMPONENT','$PREV_TESTTYPE',$PREV_COUNT, $PREV_SEVERITY]" >> $OUTPUT 
                export PREV_COMPONENT=$COMPONENT
                export PREV_TESTTYPE=$TESTTYPE
                export PREV_SEVERITY=$SEVERITY 
                export PREV_COUNT=0
            fi

            export PREV_COUNT=$(( PREV_COUNT + 1 ))
            export PREV_COMPONENT=$COMPONENT
            export PREV_TESTTYPE=$TESTTYPE
            export PREV_SEVERITY=$SEVERITY

            # Run the step
            EXPECTED=`cat $EXPECTED`
            if [ "$ID" != "" ]; then
                $($SCRIPT "$ID" "$DATA" < /dev/tty > $TMPFILE)
            else
                $($SCRIPT "$DATA" > $TMPFILE)
            fi

            # ['Africa',    'Global',             0,                               0],
            if [ $? != 0 ]; then
                echo "Failed $TESTTYPE $COMPONENT"
            elif [ "$CHECK_TYPE" == "EXACT" ]; then
                grep "$EXPECTED" $TMPFILE > /dev/null
                if [ "$?" -eq "0" ]; then 
                    echo "Passed $TESTTYPE $COMPONENT"
                else
                    echo "Failed $TESTTYPE $COMPONENT"
                fi
            elif [ "$CHECK_TYPE" == "CONTAINS" ]; then
                grep "$EXPECTED" $TMPFILE > /dev/null
                if [ "$?" -eq "0" ]; then
                    echo "Passed $TESTTYPE $COMPONENT"
                else
                    echo "Failed $TESTTYPE $COMPONENT"
                fi
            fi
        fi
    fi
done < test_plan.txt

echo "['$PREV_COMPONENT','$PREV_TESTTYPE',$PREV_COUNT, $PREV_SEVERITY]" >> $OUTPUT 

./chart2.sh

