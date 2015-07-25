#!/bin/bash
# File Name:	main.sh
# Author:	Key Zhang
# Written:	7-23-2015
# Purpose:  
. ./orm.sh
. ./view.sh

CUSER=""
STATE="Login"

function Login()
{
    view_login $1
    CUSER=`USER_getbyNO $NO`
    USER_unfold $CUSER
    if [[ $CUSER && $PASS = $iPASS ]]; then
        STATE="Index"
        return
    fi
    clear
    Login Incorrect!
}

function Index()
{
    view_index $CUSER $1
    case $RES in
        "0_1") STATE="USER_manage"
            ;;
        "0_2") STATE="COURSE_manage"
            ;;
        "1_1") STATE="Student_manage"
            ;;
        "1_2") STATE="Task_manage"
            ;;
        "1_3") STATE="Task_list"
            ;;
        "2_1") STATE="Task_edit"
            ;;
        *) Index "Wrong_Selection!"
            ;;
    esac
}

function USER_manage()
{
    maxid=`dataselect $U ID`
    local array
    local j=0
    for (( i = 0; i <= $maxid; i++ )); do
        temp=`USER_getbyid $i`
        if [[ $temp ]]; then
            array[$j]=$temp
            j=$((j+1))
        fi
    done
    view_user_list "${array[*]}"
    case $OP in
        1)
        #new user
        view_user_new
        USER_new $NEWUSER
        echo "Created!"
            ;;
        2)
        #Edit user
        view_user_target
        target=`USER_getbyNO $NO`
        view_user_edit $target
        USER_update $EDITEDUSER
        echo "Updated!"
            ;;
        3)
        #Delete User
        view_user_target
        target=`USER_getbyNO $NO`
        view_user_delete $target
        if [[ $RES = "Y" ]]; then
            USER_unfold $target
            USER_delete $id
            echo "Deleted!"
        else
            echo "Canceled!"
        fi
            ;;
        *)
          view_user_list "$1" "NO Such Choice!"
          ;;
    esac
    STATE="Index"
}

function COURSE_manage()
{
    maxid=`dataselect $C ID`
    echo $maxid
    local array
    local j=0
    for (( i = 0; i <= $maxid; i++ )); do
        temp=`COURSE_getbyid $i`
        if [[ $temp ]]; then
            array[$j]=$temp
            j=$((j+1))
        fi
    done
    view_course_list "${array[*]}"
    case $OP in
        1)
        #add course
        view_course_new
        TE=`USER_getbyNO $NO`
        USER_unfold $TE
        NEWCOURSE="0_"${id}"_"${CNAME}
        echo $NEWCOURSE
        COURSE_new $NEWCOURSE
            ;;
        2)
        #edit
        view_course_target
        COUS=`COURSE_getbyid $id`
        view_course_edit $COUS
        COURSE_update $EDITEDCOURSE
            ;;
        3)
        #delete
        view_course_target
        COUS=`COURSE_getbyid $id`
        view_course_delete $COUS
        if [[ $RES = "Y" ]]; then
            COURSE_delete $id
            echo "Deleted!"
        else
            echo "Canceled!"
        fi
            ;;
        *)
          view_course_list "$1" "NO Such Choice!"
          ;;
    esac
    # STATE="Index"
}


while [[ 1 ]]; do
    eval $STATE
done





