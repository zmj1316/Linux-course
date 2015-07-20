#!/bin/bash
# File Name:	shell1.sh
# Author:	Key Zhang
# Written:	7-20-2015
# Modified:	
#Purpose: To receive 100 integers from keyboard input, then output avg,max,min 
#and sort in increasing order
itemcount=$((100))
echo -n "please input No.0:"
read line 
array[0]=$((line))
max=$((array[0]))
min=$((array[0]))
sum=$((rray[0]))
for (( i = 1; i < $itemcount; i++ )); do
    echo -n "please input No.$i:"
    read line 
    array[i]=$((line))
    if [[ array[i] -gt max ]]; then
        max=$((array[i]))
    fi
    if [[ array[i] -lt min ]]; then
        min=$((array[i]))
    fi
    sum=$((sum+array[i]))
done
echo "max item is: $max"
echo "min item is: $min"
echo "average is $((sum/itemcount))"
echo "sorted array:"
echo ${array[@]} | tr ' ' '\n' |sort -n