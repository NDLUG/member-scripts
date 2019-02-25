#!/bin/sh

# Dell Latitude 5490
LCD="eDP1"
VGA="VGA1"
HDMI="HDMI1"

LCD_MODE="--auto"
OUT_MODE="--auto"

usage() {
    echo "Usage: xrandr_set [output] [command]"
    echo ""
    echo "Outputs:"
    echo "  hdmi, vga"
    echo ""
    echo "Commands:"
    echo "  above, below, left, right, only, off"
    exit 1
}

if [ $# != 2 ]; then
    usage
fi

case $1 in
    dvi|DVI)	OUT=$DVI;;
    vga|VGA)	OUT=$VGA;;
    hdmi|HDMI)	OUT=$HDMI;;
    *)		usage;;
esac

case $2 in 
    above)  xrandr --output $LCD --primary $LCD_MODE   --output $OUT $OUT_MODE --above $LCD   ;;
    below)  xrandr --output $LCD --primary $LCD_MODE   --output $OUT $OUT_MODE --below $LCD   ;;
    left)   xrandr --output $LCD --primary $LCD_MODE   --output $OUT $OUT_MODE --left-of $LCD ;;
    right)  xrandr --output $LCD --primary $LCD_MODE   --output $OUT $OUT_MODE --right-of $LCD;;
    only)   xrandr --output $LCD --off                 --output $OUT $OUT_MODE --primary      ;;
    clone)  xrandr --output $LCD --same-as $OUT --auto --output $OUT $OUT_MODE --primary      ;;
    off)    xrandr --output $LCD --primary $LCD_MODE   --output $OUT --off		         ;;
    *)	    usage;;
esac

#rotate-wallpaper
#transset -n i3bar 0.9
#service -u restart polybar
