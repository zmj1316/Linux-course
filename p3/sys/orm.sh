#!/bin/bash
# File Name:	orm.sh
# Author:	Key Zhang
# Written:	7-22-2015
# Purpose:  orm function

####data store function:
#dataselect <table name> <key> 
function dataselect() 
{
    #get table name
    if [[ -n $1 ]]; then
        table=$1
    fi
    #key
    if [[ -n $2 ]]; then
        key=$2
    fi
    #get value
    res=$(grep "\<$key\>" $table|cut -d'>' -f2|cut -d'<' -f1)
    #check value
    if [[  ${#res}>1 ]]; then
        echo "$res"
        return 0
    else
        return 1
    fi
}

#datainsert <table name> <key> <value>
function datainsert()
{
    #get table name
    if [[ -n $1 ]]; then
        table=$1
    fi
    #get key
    if [[ -n $2 ]]; then
        key=$2
    fi
    #get value
    if [[ -n $3 ]]; then
        value=$3
    fi
    res=$(grep "\<$key\>" $table|cut -d'>' -f2|cut -d'<' -f1)
    if [[  ${#res}>1 ]]; then
        return 1
    else
        #write record
        echo "<$key>$value<>"|cat >>$table
        #echo "Written: <$key>$value<>"
        return 0
    fi
}

#dataupdate <table name> <key> <value>
function dataupdate()
{
    if [[ -n $1 ]]; then
        table=$1
    fi
    if [[ -n $2 ]]; then
        key=$2
    fi
    if [[ -n $3 ]]; then
        value=$3
    fi
    res=$(grep "\<$key\>" $table);
    if [[  ${#res}>1 ]]; then
        #replace record
        sed -i "s/$res/<$key>$value<>/" $table
        return 0;
    else
        #No matching record
        return 1;
    fi
}

###ORM part
