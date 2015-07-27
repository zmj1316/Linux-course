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

#course manage (manager side)
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

#student_manage (teacher side)
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
    #show student list
    view_user_list "${array2[*]}" 
    #ask for option
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

#add student to certain course(teacher side) <course_id> [msg]
function Course_addstudent()
{
    #get current course
    CID=$1
    #call view
    view_course_addstudent $2 
    #get student object
    STU=`USER_getbyNO $SNO`
    if [[ ! $STU ]]; then
        #Student Not Exist
        Course_addstudent $1 "Student_Not_Exist!"
        return
    fi
    USER_unfold $STU
    #get id
    SID=$id
    ##check if the target is already in
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
            #check
            Course_addstudent $1 "Student_already_in_List!"
            return
        fi
    done
    #generate new record
    NEWUC="0_"${SID}"_"${CID}
    UC_new $NEWUC
    STATE="Index"
}

#remove student from a course(teacher side) <course_id> [msg]
function Course_deletetudent()
{
    #get course id
    CID=$1
    #get student ID
    view_course_deletestudent $2 
    STU=`USER_getbyNO $SNO`
    if [[ ! $STU ]]; then
        #Student Not Exist
        Course_deletestudent $1 "Student_Not_Exist!"
        return
    fi
    USER_unfold $STU
    SID=$id
    ##query UC table
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
    #Not found
    Course_deletetudent $1 "Student_Not_in_List!"
}

#manage task for certain course(teacher side) [msg]
function Task_manage()
{    
    ##List Courses
    #get the number of courses
    maxid=`dataselect $C ID`
    #query db
    local array
    local j=0
    for (( i = 0; i <= $maxid; i++ )); do
        temp=`COURSE_getbyid $i`
        COURSE_unfold $temp
        USER_unfold $CUSER
        #check if the course belongs to current teacher
        if [[ $temp && $uid=$id ]]; then
            array[$j]=$temp
            j=$((j+1))
        fi
    done
    #show course list
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

    #show task list
    view_task_list "${array2[*]}"
    #ask for option
    view_task_list_manage
    case $OP in
        1)
        #Add Task
        view_task_new
        NEWTASK="0_"${CCID}"_"${NAME}
        WORK_new $NEWTASK
        #sync the S-W table
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
            #sync the S-W table
            SW_SYNC_del $id
            echo "Deleted!"
        else
            echo "Canceled!"
        fi
            ;;
        4)
        #view task status
        view_task_target
        TARGET=`WORK_getbyid $id`
        WORK2ST $id
        view_SW_list_teacher "${RES[*]}"
        *)
        Task_manage "Wrong_Selection!"
            ;;
    esac
    STATE="Index"
}

function WORK2ST()
{
    RES=""
    swid=$1
    #list of SW
    #get the number of users
    maxid=`dataselect $SW ID`
    #query db
    local j=0
    for (( i = 0; i <= $maxid; i++ )); do
        temp=`SW_getbyid $i`
        #unfold SW object
        wid=`echo $temp|cut -d'_' -f3`
        if [[ $temp && $wid = $swid ]]; then
            RES[$j]=$temp
            j=$((j+1))
        fi
    done
}



function Task_edit()
{
    suid=`echo $CUSER|cut -d'_' -f1`
    #list of SW
    #get the number of users
    maxid=`dataselect $SW ID`
    #query db
    local array2
    local j=0
    for (( i = 0; i <= $maxid; i++ )); do
        temp=`SW_getbyid $i`
        #unfold SW object
        uid=`echo $temp|cut -d'_' -f2`
        if [[ $temp && $uid = $suid ]]; then
            array2[$j]=$temp
            j=$((j+1))
        fi
    done
    view_SW_list_student "${RES[*]}"

}


#Run
while [[ 1 ]]; do
    eval $STATE
done





