#!/bin/bash

STATUS_FILE=/sys/class/drm/card0-DP-1/status
STATUS=$(cat $STATUS_FILE)
MODE=$1
case "$MODE" in
    on|off)
        ACTION=$MODE
        ;;
    *)
        case $STATUS in
            disconnected)
                ACTION=off
                ;;
            connected)
                ACTION=on
                ;;
        esac
        ;;
esac

echo $ACTION >> /tmp/external-display-action

PULSE_SERVER="unix:/run/user/$UID/pulse/native"

case $ACTION in
    on)
        sleep 2
        xrandr --output LVDS1 --off --output DP1 --auto
        pactl --server "$PULSE_SERVER" set-card-profile 0 output:hdmi-stereo

        xrandr --dpi 96
        xset r rate 200 60
        setxkbmap -layout us,ru -variant ,phonetic -option grp:menu_toggle,grp_led:caps,terminate:ctrl_alt_bksp,ctrl:nocaps,compose:ralt
        ;;
    off)
        xrandr --output LVDS1 --auto --output DP1 --off
        pactl --server "$PULSE_SERVER" set-card-profile 0 output:analog-stereo+input:analog-stereo
        ;;
esac &
