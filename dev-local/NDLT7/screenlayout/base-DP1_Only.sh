#!/bin/sh
xrandr --output eDP1 --off --output HDMI1 --off --output DP1 --mode 3840x2160 --scale 1x1 --dpi 163x163 --pos 0x0 --rotate normal --output HDMI2 --off
#echo "Xft.dpi: 109" > ~/.Xresources
echo "Xft.dpi: 163" > ~/.Xresources
xrdb ~/.Xresources
