#!/bin/bash
echo "usage: tunnel.sh <target> <portsfile>"
target=$1
portsfile=$2
n=1111
for i in $(cat $portsfile); do echo -n "-L $n:127.0.0.1:$n "; n=$(($n+1111)); done
echo
n=1111
for i in $(cat $portsfile); do echo -n "-L $n:$target:$i "; n=$(($n+1111)); done
echo
