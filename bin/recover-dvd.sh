#!/bin/sh
#
# reference: https://sumofungus.wordpress.com/2010/01/19/making-backup-copies-of-damaged-dvds-using-ddrescue/

device=$1
name=$2

if [ "$device" = "" -o "$name" = "" ] ; then
    echo "Try to recover a damaged DVD using ddrescue (package: gddrescue)"
    echo "rescue <device> <name>"
    echo ""
    echo "device examples: sr0 sr1 dvd"
    exit 1
fi

dvd=/dev/$device
ddrescue="ddrescue -b 2048 -v"

echo "===> Initial pass, ignoring all errors"
echo $ddrescue -n $dvd "$name.iso" "$name.log"
$ddrescue -n $dvd "$name.iso" "$name.log"
echo "===> Pass 2: attempt 3 retries"
echo $ddrescue -d -r 3 $dvd "$name.iso" "$name.log"
$ddrescue -d -r 3 $dvd "$name.iso" "$name.log"
echo "===> Pass 3: Reverse recovery on remaining tracks"
echo "Reading blocks in reverse can sometimes read bad blocks that are otherwise"
echo "unreadable.  This can take substantially longer, though."
echo $ddrescue -d -r 3 -R $dvd "$name.iso" "$name.log"
$ddrescue -d -r 3 -R $dvd "$name.iso" "$name.log"

echo "===> Complete"
echo "
Note, it may help to run this script multiple times, removing and reinserting
disc between attempts.  It may also help to rerun the rescue moving the damaged
disc to a different drive."
