#!/bin/sh -x
. $(dirname $0)/backup_vars.txt
if [ -d "$1" ]
then \
  currentdir=$1
else \
  currentdir=$defaultdir
fi
currentdate=$(date +%F)
currentfile="${tarfileprefix}${currentdate}"
tarsnapstring="/usr/local/bin/tarsnap \
  --keyfile $tarsnapkeyfile \
  --cachedir $tarsnapcachedir"

if $tarsnapstring --list-archives | grep $currentfile
then \
  echo "file exists already, doing nothing"
else \
  for i in `seq 1 3`
  do \
    if $tarsnapstring -c -f $currentfile $currentdir 
    then \
      break
    else \
      sleep $(expr 10 \* $i)
      $tarsnapstring --fsck
      sleep $(expr 10 \* $i)
    fi
  done
fi

