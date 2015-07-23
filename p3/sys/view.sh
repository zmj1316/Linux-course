#!/bin/bash
# File Name:	view.sh
# Author:	Key Zhang
# Written:	7-23-2015
# Purpose:  User interface

#Current user
CUSER=""

#login view 
function login()
{
    echo "Please Log in"
    echo -n "Username:"
    read NO
    echo -n "Passwd:"
    read -s PASS
    LOGINRES=${NO}"_"${PASS}
}

