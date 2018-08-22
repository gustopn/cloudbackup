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

fix_tarsnap_cachedir() {
  $tarsnapstring --fsck
  $tarsnapstring -c -f $currentfile $currentdir
}

if $tarsnapstring --list-archives | grep "$currentfile" >>/dev/null
then \
  echo "file exists already, doing nothing"
else \
  $tarsnapstring -c -f $currentfile $currentdir || fix_tarsnap_cachedir
fi

