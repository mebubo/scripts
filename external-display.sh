#!/usr/bin/env bash

test -S /tmp/.X11-unix/X0 || exit 0

STATUS_FILE=/sys/class/drm/card0-DP-1/status
STATUS=$(cat $STATUS_FILE)
MODE=$1
case "$MODE" in
    on|off)
        ACTION=$MODE
        ;;
    auto)
        case $STATUS in
            disconnected)
                ACTION=off
                ;;
            connected)
                ACTION=on
                ;;
        esac
        ;;
    *)
        case $STATUS in
            disconnected)
                ACTION=off
                ;;
            connected)
                exit
                ;;
        esac
        ;;
esac

echo $ACTION >> /tmp/external-display-action

PULSE_SERVER="unix:/run/user/$UID/pulse/native"

case $ACTION in
    on)
        xrandr --output LVDS-1 --off --output DP-1 --auto
        pactl --server "$PULSE_SERVER" set-card-profile 0 output:hdmi-stereo

        xrandr --dpi 96
        xset r off
        setxkbmap -layout us,ru -variant ,phonetic -option grp:menu_toggle,grp_led:caps,terminate:ctrl_alt_bksp,ctrl:nocaps,compose:ralt
        ;;
    off)
        xrandr --output LVDS-1 --auto --output DP-1 --off
        pactl --server "$PULSE_SERVER" set-card-profile 0 output:analog-stereo+input:analog-stereo
        ;;
esac &
