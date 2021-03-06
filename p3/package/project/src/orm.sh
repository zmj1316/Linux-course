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
    if [[  $res ]]; then
        echo $res
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
    if [[  $res ]]; then
        #replace record
        sed -i "s/$res/<$key>$value<>/" $table
        return 0;
    else
        #No matching record
        return 1;
    fi
}

#datadelete table key 
function datadelete()
{
    if [[ -n $1 ]]; then
        table=$1
    fi
    if [[ -n $2 ]]; then
        key=$2
    fi
    res=$(grep "\<$key\>" $table);
    if [[  $res ]]; then
        #replace record
        sed -i "/$res/d" $table
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
#USER  :     id_TYPE_NO_NAME_PASS
#               TYPE: 0 superuser
#                     1 teacher
#                     2 student

#USER table file
U="USER.db"

function USER_unfold()
{
    #unfold the object
    id=`echo $1|cut -d'_' -f1`
    TYPE=`echo $1|cut -d'_' -f2`
    NO=`echo $1|cut -d'_' -f3`
    NAME=`echo $1|cut -d'_' -f4`
    PASS=`echo $1|cut -d'_' -f5`
}


#USER_new <USER_OBJECT>
function USER_new()
{
    #unfold the object
    USER_unfold $1
    if [[ `dataselect $U $NO"_ID"` ]]; then
        #Duplicated NO
        return 1
    fi
    #get the autoicreasing primarykey 
    id=`dataselect $U ID`
    #set id
    id=$((id + 1))
    #insrease id
    dataupdate $U ID $id

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
    USER_unfold $1
    #update into table
    dataupdate $U ${id}"_TYPE" $TYPE
    dataupdate $U ${id}"_NO" $NO
    dataupdate $U ${id}"_NAME" $NAME
    dataupdate $U ${id}"_PASS" $PASS
}

#USER_delete <USER_id>
function USER_delete()
{
    #unfold the object
    id=$1
    #update into table
    datadelete $U ${id}"_TYPE" 
    datadelete $U ${id}"_NO" 
    datadelete $U ${id}"_NAME" 
    datadelete $U ${id}"_PASS" 
}

#USER_getbyid <id>
function USER_getbyid()
{
    id=$1
    #query the data
    TYPE=`dataselect $U ${id}"_TYPE"`
    NO=`dataselect $U ${id}"_NO"`
    NAME=`dataselect $U ${id}"_NAME"`
    PASS=`dataselect $U ${id}"_PASS"`
    #fold the object
    if [[ $TYPE && $NO && $NAME && $PASS ]]; then
        echo ${id}"_"${TYPE}"_"${NO}"_"${NAME}"_"${PASS}
    else
        echo ""
    fi
    
}

#USER_getbyNO <NO>
function USER_getbyNO()
{
    NO=$1
    #use back link
    id=`dataselect $U ${NO}"_ID"`
    if [[ $id ]]; then
        echo `USER_getbyid $id`
    fi
    
}

##COURSE MODEL
#COURSE:     id_uid_NAME

#COURSE table file
C="COURSE.db"

#COURSE_new <COURSE_OBJECT>
function COURSE_new()
{
    #get the autoicreasing primarykey 
    id=`dataselect $C ID`
    #set id
    id=$((id + 1))
    #insrease id
    dataupdate $C ID $id
    #unfold the object
    uid=`echo $1|cut -d'_' -f2`
    NAME=`echo $1|cut -d'_' -f3`
    #insert into table
    datainsert $C ${id}"_uid" $uid
    datainsert $C ${id}"_NAME" $NAME
}

#COURSE_update <COURSE_OBJECT>
function COURSE_update()
{
    #unfold the object
    id=`echo $1|cut -d'_' -f1`
    uid=`echo $1|cut -d'_' -f2`
    NAME=`echo $1|cut -d'_' -f3`
    #update into table
    dataupdate $C ${id}"_uid" $uid
    dataupdate $C ${id}"_NAME" $NAME
}

#COURSE_delete <COURSE_id>
function COURSE_delete()
{
    #unfold the object
    id=$1
    #update into table
    datadelete $C ${id}"_uid" 
    datadelete $C ${id}"_NAME" 
}

#COURSE_getbyid <COURSE_OBJECT>
function COURSE_getbyid()
{
    id=$1
    #query the db
    uid=`dataselect $C ${id}"_uid"`
    NAME=`dataselect $C ${id}"_NAME"`
    #attach teacher object
    teacher=`USER_getbyid $uid`
    if [[ $uid && $NAME && $teacher ]]; then
        echo ${id}"_"${uid}"_"${NAME}"_"${teacher}
    else
        echo ""
    fi
    
}

##

##WORK MODEL
#WORK  :     id_cid_NAME

#WORK table file
W="WORK.db"

function WORK_unfold()
{
    #unfold the object
    id=`echo $1|cut -d'_' -f1`
    cid=`echo $1|cut -d'_' -f2`
    NAME=`echo $1|cut -d'_' -f3`
    CNAME=`echo $1|cut -d'_' -f6`
}

#WORK_new <WORK_OBJECT>
function WORK_new()
{
    #get the autoicreasing primarykey 
    id=`dataselect $W ID`
    #set id
    id=$((id + 1))
    #insrease id
    dataupdate $W ID $id
    #unfold the object
    cid=`echo $1|cut -d'_' -f2`
    NAME=`echo $1|cut -d'_' -f3`
    #insert into table
    datainsert $W ${id}"_cid" $cid
    datainsert $W ${id}"_NAME" $NAME   
}

#WORK_update <WORK_OBJECT>
function WORK_update()
{
    #unfold the object
    id=`echo $1|cut -d'_' -f1`
    cid=`echo $1|cut -d'_' -f2`
    NAME=`echo $1|cut -d'_' -f3`
    #update into table
    dataupdate $W ${id}"_cid" $cid
    dataupdate $W ${id}"_NAME" $NAME
}

#WORK_delete <WORK_id>
function WORK_delete()
{
    #unfold the object
    id=$1
    #update into table
    datadelete $W ${id}"_cid" 
    datadelete $W ${id}"_NAME" 
}

#WORK_getbyid <WORK_OBJECT>
function WORK_getbyid()
{
    id=$1
    cid=`dataselect $W ${id}"_cid"`
    NAME=`dataselect $W ${id}"_NAME"`
    #attach the course
    COURSE=`COURSE_getbyid $cid`
    #return WORK_OBJECT 
    if [[ $cid && $NAME && $COURSE ]]; then
        echo ${id}"_"${cid}"_"${NAME}"_"${COURSE}
    else 
        echo ""
    fi
    
}



##RELATION MODEL
#ST-WORK RELATION:   id_uid_wid_STAT
#                               STAT: 0 Not done
#                                     1 Done

R="S-W.db"

#RELA_new <RELA_OBJECT>
function SW_new()
{
    #get the autoicreasing primarykey 
    id=`dataselect $R ID`
    #set id
    id=$((id + 1))
    #insrease id
    dataupdate $R ID $id
    #unfold the object
    uid=`echo $1|cut -d'_' -f2`
    wid=`echo $1|cut -d'_' -f3`
    STAT=`echo $1|cut -d'_' -f4`
    #insert into table
    datainsert $R ${id}"_uid" $uid
    datainsert $R ${id}"_wid" $wid
    datainsert $R ${id}"_STAT" $STAT 
}

#RELA_update <SW_object>
function SW_update()
{
    #unfold the object
    # id=`echo $1|cut -d'_' -f1`
    id=$1
    # uid=`echo $1|cut -d'_' -f2`
    # wid=`echo $1|cut -d'_' -f3`
    # STAT=`echo $1|cut -d'_' -f4`
    # #update into table
    # dataupdate $R ${id}"_uid" $uid
    # dataupdate $R ${id}"_wid" $wid
    dataupdate $R ${id}"_STAT" 1
}

function SW_getbyid()
{
    id=$1
    #query the db
    uid=`dataselect $R ${id}"_uid"`
    wid=`dataselect $R ${id}"_wid"`
    STAT=`dataselect $R ${id}"_STAT"`
    USER=`USER_getbyid $uid`
    WORK=`WORK_getbyid $wid`
    echo ${id}"_"${uid}"_"${wid}"_"${STAT}"_"${USER}"_"${WORK}
}


#USER-COURSE RELATION:   id_uid_cid


UC="U-C.db"

#RELA_new <RELA_OBJECT>
function UC_new()
{
    #get the autoicreasing primarykey 
    id=`dataselect $UC ID`
    #set id
    id=$((id + 1))
    #insrease id
    dataupdate $UC ID $id
    #unfold the object
    uid=`echo $1|cut -d'_' -f2`
    cid=`echo $1|cut -d'_' -f3`
    #insert into table
    datainsert $UC ${id}"_uid" $uid
    datainsert $UC ${id}"_cid" $cid
}

#RELA_delete <RELA_OBJECT>
function UC_delete()
{
    #unfold the object
    id=`echo $1|cut -d'_' -f1`
    uid=`echo $1|cut -d'_' -f2`
    cid=`echo $1|cut -d'_' -f3`
    #delete into table
    datadelete $UC ${id}"_uid" $uid
    datadelete $UC ${id}"_cid" $cid
}

#UC_getbyid <UC_id>
function UC_getbyid()
{
    id=$1
    #query the db
    uid=`dataselect $UC ${id}"_uid"`
    cid=`dataselect $UC ${id}"_cid"`
    if [[ $uid && $cid  ]]; then
        echo ${id}"_"${uid}"_"${cid}
    else
        echo ""
    fi
    
}

##sync the student-task relation
#create relation for new work and all students who are 
#in this course
function SW_SYNC_new()
{
    #get WORK id
    wid=$1
    WORK=`WORK_getbyid $wid`
    WORK_unfold $WORK
    ##search in UC table for student id
    maxid=`dataselect $UC ID`
    #query db
    local j=0
    for (( i = 0; i <= $maxid; i++ )); do
        temp=`UC_getbyid $i`
        #unfold WORK object
        sid=`echo $temp | cut -d'_' -f2`
        scid=`echo $temp | cut -d'_' -f3`

        if [[ $temp && $cid = $scid ]]; then
            #generate new S-W record
            NEWSW="0_"${sid}"_"${wid}"_0"
            SW_new $NEWSW
        fi
    done
}

#delete the S-W relation for all students
##TODO :TEST not done!
function SW_SYNC_del()
{
    swid=$1
    #search for S-W record
    maxid=`dataselect $R ID`
    local j=0
    for (( i = 0; i <= $maxid; i++ )); do
        temp=`SW_getbyid $i`
        #unfold S-W object
        wid=`echo $temp|cut -d'_' -f3`
        #check the wid
        if [[ $temp && $wid = $swid ]]; then
            SW_delete $temp
        fi
    done
}


# ###unit test:
# `./initdb.sh`

# U_SU="0_0_000_root_root"
# U_TE="0_1_010_teather_teacher"
# U_ST="0_2_100_stu_student"

# USER_new $U_SU
# USER_new $U_TE
# USER_new $U_ST

# USER_getbyNO 010
# temp=`USER_getbyid 3`
# temp=${temp}"s"
# USER_update $temp
# USER_delete 1

# C_1="0_2_Linux"
# C_2="0_2_OOP"

# COURSE_new $C_1
# COURSE_new $C_2

# COURSE_getbyid 1
# temp=`COURSE_getbyid 1`
# temp=${temp}"-is-fun"
# COURSE_update $temp
# COURSE_delete 1

# W_1="0_1_shell"

# WORK_new $W_1

# temp=`WORK_getbyid 1`
# temp=${temp}"-program"
# WORK_update $temp
# WORK_delete 1


##relation test
# USER_getbyid 4
# UC_getbyid 1