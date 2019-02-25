#!/bin/sh

# Configuration

WALLPAPER_PATH=$HOME/share/image/wallpaper

# Functions

get_screens() {
    xrandr | sed 's/primary //' | grep -Ec ' connected [0-9]+x[0-9]+'
}

get_wallpapers() {
    ls $WALLPAPER_PATH/*.jpg | shuf -n $(get_screens)
}

# Main Execution

get_wallpapers | xargs feh --no-fehbg --bg-max
