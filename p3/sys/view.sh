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

#login view 
#return login session
function view_login()
{
    clear
    echo "Please Log in"
    echo -n "Username:"
    read NO
    echo -n "Passwd:"
    read -s PASS
    LOGINRES=${NO}"_"${PASS}
}

#USER manage view
#user_list <USER_array> [errormsg]
#return OP 
function view_user_list()
{
    clear
    local temp=($1)
    #Error message
    if [[ $2 ]]; then
        echo -e "\033[41;37m$2\033[0m"
    fi
    #head
    printf "%-4s%-5s%-10s%-15s\n" id TYPE LOGINNAME NAME
    for i in ${temp[@]} ; do
        USER_unfold $i
        #explain the TYPE
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
    #read operation
    echo "operations:"
    echo -e "\t1:Add User"
    echo -e "\t2:Edit User"
    echo -e "\t3:Delete User"
    read -p "Please select:" OP
    # case $OP in
    #     1)view_user_new
    #     #new user
    #         ;;
    #     2)view_user_edit
    #     #Edit user
    #         ;;
    #     3)view_user_delete
    #     #Delete User
    #         ;;
    #     *)
    #       view_user_manage "$1" "NO Such Choice!"
    #       ;;
    # esac
}
#create user 
#view_user_new [err msg]
function view_user_new()
{
    if [[ $1 ]]; then
        echo -e "\033[41;37m$1\033[0m"
    fi
    echo "Now create new user: "
    read -p "TYPE [0:SU][1:TE][2:ST] : " TYPE
    case $TYPE in
        0)TYPE=0
            ;;
        1)TYPE=1
            ;;
        2)TYPE=2
            ;;
        *)
        #TYPE out of raange
        view_user_new "TYPE Error!"
            return
            ;;
    esac
    read -p "LOGINNAME: " NO
    read -p "NAME: " NAME
    read -p "PASSWORD: " PASS1
    read -p "Type again: " PASS2
    if [[ ! $PASS1 = $PASS2 ]]; then
        view_user_new "Type password again!"
        return 
    fi
    id=0
    PASS=$PASS1
    NEWUSER=`USER_fold`
}

#get the target NO
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
    USER_unfold $i
    #explain the TYPE
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
    
}

##test
# a[0]="1_0_root_root"
# a[1]="2_1_010_teacher"
# view_user_manage "${a[*]}"

# view_user_new
# echo $NEWUSER

view_user_edit "1_1_NO_NAME_PASS"
echo $EDITEDUSER