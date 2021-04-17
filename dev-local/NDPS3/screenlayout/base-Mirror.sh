#!/bin/sh
xrandr --output eDP1 --primary --mode 1920x1080 --scale 1x1 --dpi 96 --pos 0x0 --rotate normal --output HDMI1 --off --output DP1 --mode 1920x1080 --scale 1x1 --pos 0x0 --rotate normal --output HDMI2 --off
echo "Xft.dpi: 96" > ~/.Xresources
xrdb -merge ~/.Xresources
