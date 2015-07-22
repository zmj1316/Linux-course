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
##OBJECT DEFINE:
#USER  :     id_TYPE_NO_NAME_PASS
#               TYPE: 0 superuser
#                     1 teacher
#                     2 student
#COURSE:     id_uid_NAME
#WORK  :     id_cid_NAME
#RELATION:   id_uid_wid_STAT
#                       STAT: 0 Not done
#                             1 Done

##USER MODEL
USER_SU="0_0_0_0_0"
USER_TE="1_1_1_1_1"
USER_ST="2_2_2_2_2"

U="USER.db"

#USER_new <USER_OBJECT>
function USER_new()
{
    #get the autoicreasing primarykey 
    id=`dataselect $U ID`
    #set id
    id=$((id + 1))
    #insrease id
    dataupdate $U ID $id
    #unfold the object
    TYPE=`echo $1|cut -d'_' -f2`
    NO=`echo $1|cut -d'_' -f3`
    NAME=`echo $1|cut -d'_' -f4`
    PASS=`echo $1|cut -d'_' -f5`
    #insert into table
    datainsert $U ${id}"_TYPE" $TYPE
    datainsert $U ${id}"_NO" $NO
    datainsert $U ${id}"_NAME" $NAME
    datainsert $U ${id}"_PASS" $PASS
    datainsert $U ${NO}"_ID" $id
}

#USER_update <USER_OBJECT>
function USER_update()
{
    #unfold the object
    id=`echo $1|cut -d'_' -f1`
    TYPE=`echo $1|cut -d'_' -f2`
    NO=`echo $1|cut -d'_' -f3`
    NAME=`echo $1|cut -d'_' -f4`
    PASS=`echo $1|cut -d'_' -f5`
    #update into table
    dataupdate $U ${id}"_TYPE" $TYPE
    dataupdate $U ${id}"_NO" $NO
    dataupdate $U ${id}"_NAME" $NAME
    dataupdate $U ${id}"_PASS" $PASS
}

#USER_getbyid <id?
function USER_getbyid()
{
    id=$(($1))
    TYPE=dataselect $U ${id}"_TYPE"
    NO=dataselect $U ${id}"_NO"
    NAME=dataselect $U ${id}"_NAME"
    PASS=dataselect $U ${id}"_PASS"
    echo ${id}"_"${TYPE}"_"${NO}"_"${NAME}"_"${PASS}
}
