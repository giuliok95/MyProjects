#!/bin/bash

export WIDGET_CONTROL=$1,$2,$3,$4,$5
if [ -z $(echo $WIDGET_CONTROL | tr -d ',') ]
    then
./mem.sh
./cpu.sh
    else
        for i in 1 2 3 4 5
        do  scriptName=$(echo $WIDGET_CONTROL | cut -d "," -f $i )
            bash $scriptName.sh
            echo
        done
    fi
unset WIDGET_CONTROL






















# WIDGET_CONTROL="$1,$2,$3,$4,$5"
# if [ -z $WIDGET_CONTROL]
#     then
# ./mem.sh
# ./cpu.sh
#     else
#         for i in 1 2 3 4 5
#         do  scriptName=$(echo $WIDGET_CONTROL | cut -d "," -f $i)
#             bash $scriptName.sh
#         done
#     fi