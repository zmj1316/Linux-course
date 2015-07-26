#!/bin/bash
# File Name:	main.sh
# Author:	Key Zhang
# Written:	7-23-2015
# Purpose:  
. ./orm.sh
. ./view.sh

CUSER=""
STATE="Login"

#USer login [msg]
function Login()
{
    #call view
    view_login $1
    #get user
    CUSER=`USER_getbyNO $NO`
    USER_unfold $CUSER
    #check password
    if [[ $CUSER && $PASS = $iPASS ]]; then
        #goto index manu
        STATE="Index"
        return
    fi
    clear
    #passwd not match or user not exist
    Login Incorrect!
}

#index user manu
function Index()
{
    #call view
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

#USER manage 
function USER_manage()
{
    #get the number of users
    maxid=`dataselect $U ID`
    #query db
    local array
    local j=0
    for (( i = 0; i <= $maxid; i++ )); do
        temp=`USER_getbyid $i`
        if [[ $temp ]]; then
            array[$j]=$temp
            j=$((j+1))
        fi
    done
    #call view
    view_user_list "${array[*]}"
    view_user_list_manage
    #selection
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
        #comfirm
        if [[ $RES = "Y" ]]; then
            USER_unfold $target
            USER_delete $id
            echo "Deleted!"
        else
            echo "Canceled!"
        fi
            ;;
        *)
        #other choice
          view_user_list "$1" "NO Such Choice!"
          ;;
    esac
    #go back
    STATE="Index"
}

#course manage 
function COURSE_manage()
{
    #get the number of courses
    maxid=`dataselect $C ID`
    #query db
    local array
    local j=0
    for (( i = 0; i <= $maxid; i++ )); do
        temp=`COURSE_getbyid $i`
        if [[ $temp ]]; then
            array[$j]=$temp
            j=$((j+1))
        fi
    done
    #call view
    view_course_list "${array[*]}"
    view_course_list_manage
    #selection
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
    STATE="Index"
}

function Student_manage()
{
    #get the number of courses
    maxid=`dataselect $C ID`
    #query db
    local array
    local j=0
    for (( i = 0; i <= $maxid; i++ )); do
        temp=`COURSE_getbyid $i`
        COURSE_unfold $temp
        USER_unfold $CUSER
        if [[ $temp && $uid=$id ]]; then
            array[$j]=$temp
            j=$((j+1))
        fi
    done
    #call view
    view_course_list "${array[*]}" $1
    view_course_list_teacher
    
    #get the number of users
    maxid=`dataselect $UC ID`
    #query db
    local array2
    local j=0
    for (( i = 0; i <= $maxid; i++ )); do
        temp=`UC_getbyid $i`
        #unfold U-C object
        uid=`echo $temp|cut -d'_' -f2`
        cid=`echo $temp|cut -d'_' -f3`
        if [[ $temp && $cid = $CCID ]]; then
            array2[$j]=`USER_getbyid $uid`
            j=$((j+1))
        fi
    done
    view_user_list "${array2[*]}" 
    view_user_list_teacher
    case $OP in
        1) STATE="Course_addstudent $CCID"
            ;;
        2) STATE="Course_deletetudent $CCID"
            ;;
        *) Student_manage "Wrong_Selection!"
            ;;
    esac

}

function Course_addstudent()
{
    CID=$1
    view_course_addstudent $2 
    STU=`USER_getbyNO $SNO`
    if [[ ! $STU ]]; then
        #Student Not Exist
        Course_addstudent $1 "Student_Not_Exist!"
        return
    fi
    USER_unfold $STU
    SID=$id
    #get the number of users
    maxid=`dataselect $UC ID`
    #query db
    local array
    local j=0
    for (( i = 0; i <= $maxid; i++ )); do
        temp=`UC_getbyid $i`
        #unfold U-C object
        uid=`echo $temp|cut -d'_' -f2`
        cid=`echo $temp|cut -d'_' -f3`
        if [[ $temp && $cid = $CID && $uid = $SID ]]; then
            Course_addstudent $1 "Student_already_in_List!"
            return
        fi
    done
    NEWUC="0_"${SID}"_"${CID}
    UC_new $NEWUC
    STATE="Index"
}

function Course_deletetudent()
{
    CID=$1
    view_course_deletestudent $2 
    STU=`USER_getbyNO $SNO`
    if [[ ! $STU ]]; then
        #Student Not Exist
        Course_deletestudent $1 "Student_Not_Exist!"
        return
    fi
    USER_unfold $STU
    SID=$id
    #get the number of users
    maxid=`dataselect $UC ID`
    #query db
    local j=0
    for (( i = 0; i <= $maxid; i++ )); do
        temp=`UC_getbyid $i`
        #unfold U-C object
        uid=`echo $temp|cut -d'_' -f2`
        cid=`echo $temp|cut -d'_' -f3`
        if [[ $temp && $cid = $CID && $uid = $SID ]]; then
            UC_delete $temp
            STATE="Index"
            return
        fi
    done
    Course_deletetudent $1 "Student_Not_in_List!"
}

function Task_manage()
{    
    #get the number of courses
    maxid=`dataselect $C ID`
    #query db
    local array
    local j=0
    for (( i = 0; i <= $maxid; i++ )); do
        temp=`COURSE_getbyid $i`
        COURSE_unfold $temp
        USER_unfold $CUSER
        if [[ $temp && $uid=$id ]]; then
            array[$j]=$temp
            j=$((j+1))
        fi
    done
    #call view
    view_course_list "${array[*]}" $1
    view_course_list_task

    #list of TASK
    #get the number of users
    maxid=`dataselect $W ID`
    #query db
    local array2
    local j=0
    for (( i = 0; i <= $maxid; i++ )); do
        temp=`WORK_getbyid $i`
        #unfold WORK object
        cid=`echo $temp|cut -d'_' -f2`
        if [[ $temp && $cid = $CCID ]]; then
            array2[$j]=$temp
            j=$((j+1))
        fi
    done

    view_task_list "${array2[*]}"
    view_task_list_manage
    case $OP in
        1)
        #Add Task
        view_task_new
        NEWTASK="0_"${CCID}"_"${NAME}
        WORK_new $NEWTASK
        SW_SYNC_new $((id - 1))
            ;;
        2)
        #Edit Task
        view_task_target
        TARGET=`WORK_getbyid $id`
        view_task_edit $TARGET
        WORK_update $NEWWORK
            ;;
        3)
        #delete task
        view_task_target
        TARGET=`WORK_getbyid $id`
        view_task_delete $TARGET
        if [[ $RES = "Y" ]]; then
            WORK_delete $id
            SW_SYNC_del $id
            echo "Deleted!"
        else
            echo "Canceled!"
        fi
            ;;
        *)
        Task_manage "Wrong_Selection!"
            ;;
    esac
}

#Run
while [[ 1 ]]; do
    eval $STATE
done





