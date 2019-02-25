#!/bin/bash

# A super simple bookmarking system.
# $ bk "https://coollink.com" # saves a link
# $ bkls                      # easy way to view links from this month

# This is half a step above pasting links into a plain text file.

# Made because most bookmarking systems are made to work for the use case of
# "I'll use this once a week for the next semester" rather than
# "Someday in the future I want to read this!"
# Pocket kind of works for that but I found the advertisements to be pretty invasive.

# Where bookmarks should be stored
bookmarks=~/bookmarks

# list current months bookmarks
bkls () {
  name=$bookmarks/$(date +%b%Y | tr [:upper:] [:lower:]).txt
  cat $name
}

# bookmark following text.
# Be careful of not quoting, if you use a "*" for instance it will expand as normal unless quoted,
# and you'll only realize it when you're looking through your bookmarks later.
bk () {
  mkdir -p $bookmarks/backups
  name=$bookmarks/$(date +%b%Y | tr [:upper:] [:lower:]).txt
  backupname=$bookmarks/backups/$(date +%F).txt.bak
  echo "making backup in $backupname"
  cp $name $backupname
  before=$(wc -l < $name)
  echo $* >> $name
  after=$(wc -l < $name)
  echo "$before before, $after after in $name"
}
