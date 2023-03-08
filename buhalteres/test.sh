#!/bin/bash
array=(20
21
22
23
24
25
26
27
28
29
30
31
32)

for (( i = 0 ; i < $((${#array[@]}-1)) ; i++ )); do
if [ $((${array[$i]}+1)) -ne ${array[$(($i + 1))]} ] ;then
    IP_NUMBER="$((${array[$i]}+1))"
    break
else IP_NUMBER=$((${array[$i+1]} + 1))
fi
done

echo $IP_NUMBER