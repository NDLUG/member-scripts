#!/bin/sh

# Backup streamliner for easy regular backups with Borg.  To be run as root.

# This one is pretty tailored to one particular way of using Borg,
# so if it feels like you have to stretch it it might mean you should make your own from scratch.

# To be used with Borg, a deduplicating encrypted backup system supporting incremental backups.
# https://www.borgbackup.org/

# Where in the filesystem you want to mount the external drive's partition that contains the backup:
mount_point=replace-with-your-own

# The uuid of your external drive's partition in question
# (you can find this with "blkid" when the drive is plugged in):
uuid=replace-with-your-own

# The name of the borg repo:
repo=repo-name-here

# The directories you want to backup by default
dirs="/home/ /etc /var/lib /usr/local"

# --one-file-system: don't jump across filesystems,
#   otherwise could get weird if this drive is mounted amoung the files its backing up...
# -v: verbose.
# --exclude-from exclude.txt: contains directories you *don't* want to backup.
#   I find myself putting things like ~/.cache in here, anything having to do with npm, etc.
# -p: show progress information.
# --stats: information on amount transferred, how much deduplicated, etc.
borgopts="--one-file-system -v --exclude-from exclude.txt -p --stats"

# What you want your backups to be named in your repo
backupname="put_yours_here"

cleanup () {
  ret=$1
  if [ ! $ret ] ; then
    echo "Other problems.  Exiting."
  fi

  if ! umount $mount_point 2> /dev/null; then
    echo "Problems unmounting.  Don't pull the cord."
    ret=1
  else
    echo "Unmounted!"
  fi

  exit $ret
}
trap 'cleanup 1' INT

# Bail if borg is already running, maybe previous run didn't finish
if pidof -x borg >/dev/null; then
    echo "Backup already running."
    exit
fi

if [ "`whoami`" != "root" ] ; then
  echo "This script must be run as root."
  exit
fi

if ! mount -U $uuid $mount_point 2> /dev/null; then
  echo "Couldn't mount."
  exit
fi

# Do the backup.  The options largely configure the name.
borg create $borgopts $mount_point/$repo::$backupname-{now:%Y-%m-%d} $dirs

# If you want to prune the amount of backups you have,
# you can uncomment this line to prune certain backups depending on how long ago they were made.
# See borg docs for details.

#borg prune -v --list $mount_point/$repo --prefix '$(backupname)-' --keep-daily=5 --keep-weekly=4 --keep-monthly=6 --keep-yearly=2

cleanup 0
