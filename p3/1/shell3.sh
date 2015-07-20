#!/bin/bash
# File Name:	shell3.sh
# Author:	Key Zhang
# Written:	7-20-2015
# Modified:	
# Purpose:	TO check if a string is a palindrome
# Brief Description:	Use build-in commands
echo -n "Please input the string:"
read line
#get the characters
str=$(echo $line|grep -Eo "[a-zA-Z]+"|tr -d '\n' )
for (( i = 1; i <= ${#str}; i++ )); do
    c1=$(echo -n $str|cut -c $i)
    c2=$(echo -n $str|cut -c $((${#str}-i+1)))
    if [[ $c1 != $c2 ]]; then
        echo "No"
        exit 0
    fi
done
echo "Yes"