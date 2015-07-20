#!/bin/bash
# File Name:	shell1.sh
# Author:	Key Zhang
# Written:	7-17-2015
# Purpose:  Data store function
table="test.db"
key="testkey"
value="testv"
if [[ -n $1 ]]; then
    table=$1
fi
if [[ -n $2 ]]; then
    key=$2
fi
if [[ -n $3 ]]; then
    value=$3
fi
if [[ -e $table ]]; then
    echo "OK"
else
    echo "New Table!"
    touch $table
fi
res=$(grep "\<$key\>" $table|cut -d'>' -f2|cut -d'<' -f1)
if [[  ${#res}>1 ]]; then
    echo "found: $res"
else
    echo "<$key>$value<\\$key>"|cat >>$table
    echo "Written: <$key>$value<\\$key>"
fi
