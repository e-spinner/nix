#!/bin/bash

function send_notification() {
  percent=$(($1 * 100 / 96000))
  dunstify -a "waybarctl" -u low  -r 618 -h int:value:$percent "${percent}%" -t 1500
}


value=$(brightnessctl get)


case $1 in
    up)
    brightnessctl set +5%
    # send_notification $value
    ;;
    down)
    if (( value >= 9600 )); then
        brightnessctl set 5%-
        # send_notification $value
    fi
    ;;
esac

