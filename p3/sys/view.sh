#!/bin/bash
# File Name:	view.sh
# Author:	Key Zhang
# Written:	7-23-2015
# Purpose:  User interface

##User unfold
#input userobject
#return user attributes
function USER_unfold()
{
    #unfold the object
    id=`echo $1|cut -d'_' -f1`
    TYPE=`echo $1|cut -d'_' -f2`
    NO=`echo $1|cut -d'_' -f3`
    NAME=`echo $1|cut -d'_' -f4`
    PASS=`echo $1|cut -d'_' -f5`
}

##User fold
#input user attributes
#return user object
function USER_fold()
{
    local USER
    USER=${id}"_"${TYPE}"_"${NO}"_"${NAME}"_"${PASS}
    echo $USER
}
#
function COURSE_unfold()
{
    #unfold the object
    id=`echo $1|cut -d'_' -f1`
    uid=`echo $1|cut -d'_' -f2`
    NAME=`echo $1|cut -d'_' -f3`
    TNO=`echo $1|cut -d'_' -f6`
    TNAME=`echo $1|cut -d'_' -f7`
}

function COURSE_fold()
{
    local COURSE
    COURSE=${id}"_"${uid}"_"${NAME}
    echo $COURSE
}
#login view 
#return login session
function view_login()
{
    clear
    if [[ $1 ]]; then
        echo -e "\033[41;37m$1\033[0m"
    fi
    echo "Please Log in"
    echo -n "Username:"
    read NO
    echo -n "Passwd:"
    read -s iPASS
}

#index view
#view <current user> [msg]
function view_index()
{
    clear
    #display message
    if [[ $2 ]]; then
        echo -e "\033[41;37m$2\033[0m"
    fi
    #get TYPE from USER object
    USER_unfold $1
    echo "options:"
    case $TYPE in
        0)
        #SU menu
        echo -e "\t1:USER manage"
        echo -e "\t2:Course manage"
            ;;
        1)
        #TE
        echo -e "\t1:student manage"
        echo -e "\t2:Task manage"
        echo -e "\t3:Task check"
            ;;
        2)
        #student
        echo -e "\t1:Task Edit"
            ;;
        *)
        return
            ;;
    esac
    #get selection
    read -p "  input: " CMD
    RES=$TYPE"_"$CMD
}



#USER manage view
#user_list <USER_array> [errormsg]
#return OP 
function view_user_list()
{
    clear
    local temp=($1)
    #display message
    if [[ $2 ]]; then
        echo -e "\033[41;37m$2\033[0m"
    fi
    #head
    printf "%-4s%-5s%-10s%-15s\n" id TYPE LOGINNAME NAME
    for i in ${temp[@]} ; do
        USER_unfold $i
        #translate the TYPE
        case $TYPE in
            0)TYPE="SU"
                ;;
            1)TYPE="TE"
                ;;
            2)TYPE="ST"
                ;;
        esac
        printf "%-4s%-5s%-10s%-15s\n" $id $TYPE $NO $NAME
    done
    echo
    echo
    # read operation
    echo "operations:"
    echo -e "\t1:Add User"
    echo -e "\t2:Edit User"
    echo -e "\t3:Delete User"
    read -p "Please select:" OP
}
#create user 
#view_user_new [err msg]
function view_user_new()
{
    #display message
    if [[ $1 ]]; then
        echo -e "\033[41;37m$1\033[0m"
    fi
    echo "Now create new user: "
    #USER TYPE
    read -p "TYPE [0:SU][1:TE][2:ST] : " TYPE
    case $TYPE in
        0)TYPE=0
            ;;
        1)TYPE=1
            ;;
        2)TYPE=2
            ;;
        *)
        #TYPE out of range
        view_user_new "TYPE Error!"
            return
            ;;
    esac
    read -p "LOGINNAME: " NO
    read -p "NAME: " NAME
    read -p "PASSWORD: " PASS1
    read -p "Type again: " PASS2
    #check the passwd
    if [[ ! $PASS1 = $PASS2 ]]; then
        view_user_new "Type password again!"
        return 
    fi
    id=0
    PASS=$PASS1
    NEWUSER=`USER_fold`
}

#get the target user NO
function view_user_target()
{
    echo  "Please input the LOGINNAME of the target:"
    read -p "LOGINNAME: " NO
}

#edit user <user object>
function view_user_edit()
{
    #Error message
    if [[ $2 ]]; then
        echo -e "\033[41;37m$2\033[0m"
    fi
    USER_unfold $1
    read -p "Current LOGINNAME is $NO input new: " NO
    read -p "Current NAME is $NAME input new: " NAME
    EDITEDUSER=`USER_fold`
}

#user delete <Usser OBJECT
function view_user_delete()
{
    echo "Are you sure to delete the following user?"
    USER_unfold $1s
    #translate the TYPE
    case $TYPE in
        0)TYPE="SU"
            ;;
        1)TYPE="TE"
            ;;
        2)TYPE="ST"
            ;;
    esac
    printf "%-4s%-5s%-10s%-15s\n" $id $TYPE $NO $NAME
    read -p "Enter [Y/N]" RES
}

##COURSE VIEW
#course list
function view_course_list()
{
    clear
    local temp=($1)
    #Error message
    if [[ $2 ]]; then
        echo -e "\033[41;37m$2\033[0m"
    fi
    #head
    printf "%-4s%-15s%-15s%-10s\n" id  NAME TE_NO TE_NAME 
    for i in ${temp[@]} ; do
        COURSE_unfold $i
        printf "%-4s%-15s%-15s%-10s\n" $id $NAME $TNO $TNAME
    done

}

function view_course_list_manage()
{
    echo
    echo
    #read operation
    echo "operations:"
    echo -e "\t1:Add Course"
    echo -e "\t2:Edit Course"
    echo -e "\t3:Delete Course"
    read -p "Please select:" OP
}
function view_course_list_student()
{
    echo
    echo
    #read operation
    read -p "Type the id of the course to edit" CID
}
#view_course_new [err msg]
function view_course_new()
{
    #display message
    if [[ $1 ]]; then
        echo -e "\033[41;37m$1\033[0m"
    fi
    echo "Now create new course: "
    read -p "Teacher LOGINNAME: " NO
    read -p "Course name: " CNAME
}


#get the target id
function view_course_target()
{
    echo  "Please input the id of the target course:"
    read -p "id: " id
}

#edit course <course object> [msg]
function view_course_edit()
{
    #display message
    if [[ $2 ]]; then
        echo -e "\033[41;37m$2\033[0m"
    fi
    COURSE_unfold $1
    read -p "Current Teacher id is $uid input new: " uid
    read -p "Current COURSENAME is $NAME input new: " NAME
    EDITEDCOURSE=`COURSE_fold`
}

#course delete <course OBJECT
function view_course_delete()
{
    echo "Are you sure to delete the following course?"
    COURSE_unfold $1
    #explain the TYPE
    printf "%-4s%-10s%-15s\n" $id $uid $NAME
    read -p "Enter [Y/N]" RES
}




##test
# a[0]="1_0_root_root"
# a[1]="2_1_010_teacher"
# view_user_manage "${a[*]}"

# view_user_new
# echo $NEWUSER

# view_user_edit "1_1_NO_NAME_PASS"
# echo $EDITEDUSER

# a[0]="0_2_aaa"
# a[1]="1_2_bbb"
# a[3]="3_2_sdf"
# # view_course_list "${a[*]}"
# view_course_edit ${a[0]}
# echo $EDITEDCOURSE
