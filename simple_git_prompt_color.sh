#!/bin/bash

# Git prompt addition with color.

# You can add this to a ~/.bashrc so that when you are in a git repo,
# a color coded piece of the prompt will tell you which branch you're on, and whether it's clean and pushed.

# Define a few colors
COLOR_RED="\033[0;31m"
COLOR_YELLOW="\033[0;33m"
COLOR_GREEN="\033[0;32m"
COLOR_OCHRE="\033[38;5;95m"
COLOR_BLUE="\033[0;34m"
COLOR_WHITE="\033[0;37m"
COLOR_RESET="\033[0m"

# This associates git states to colors
function git_color {
  local git_status="$(git status 2> /dev/null)"
  # https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.9.1.txt
  # git 2.9.1 changed the wording, so this supports both
  if [[ ! $git_status =~ "working "(tree|directory)" clean" ]]; then
    echo -e $COLOR_RED
  elif [[ $git_status =~ "Your branch is ahead of" ]]; then
    echo -e $COLOR_YELLOW
  elif [[ $git_status =~ "nothing to commit" ]]; then
    echo -e $COLOR_GREEN
  else
    echo -e $COLOR_OCHRE
  fi
}
function git_branch {
  local git_status="$(git status 2> /dev/null)"
  local on_branch="On branch ([^${IFS}]*)"
  local on_commit="HEAD detached at ([^${IFS}]*)"
  if [[ $git_status =~ $on_branch ]]; then
    local branch=${BASH_REMATCH[1]}
    echo "($branch)"
  elif [[ $git_status =~ $on_commit ]]; then
    local commit=${BASH_REMATCH[1]}
    echo "($commit)"
  fi
}

# You can other modifications to PS1 before or after these:
# colors git status
PS1+="\[\$(git_color)\]"
# prints current branch
PS1+="\$(git_branch)"
# resets to normal color
PS1+="\[$COLOR_RESET\]"
export PS1
