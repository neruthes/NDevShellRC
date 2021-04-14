#!/bin/sh
xrandr --output eDP1 --primary --mode 1920x1080 --scale 1x1 --dpi 192 --pos 0x0 --rotate normal --output HDMI1 --off --output DP1 --off --output HDMI2 --off
echo "Xft.dpi: 192" > ~/.Xresources
xrdb ~/.Xresources
