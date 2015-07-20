#!/bin/bash
# File Name:	shell1.sh
# Author:	Key Zhang
# Written:	7-17-2015
# Modified:	
# Purpose:	To count the number of normal directory and excuteble files, 
# and the number of bytes under given directory which is passed in through argument.
# Brief Description:	Use build-in commands
if [[ $1  ]]; then
    #Use PWD as default
    dir=$1
else
    #set Description
    dir=$(pwd)
fi
common=$(find $dir -type f|wc -l)
echo "common files: $common"
sub=$(find $dir -type d|wc -l)
echo "sub directory: $((sub-1))"
exe=$(find $dir -executable -type f|wc -l)
echo "executable files：$exe"
count=$(du -Sb $dir|grep -Eo "^[0-9]+")
#exclude directory size(4k)
echo "Byte count: $((count-4096))"