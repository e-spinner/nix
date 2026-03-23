#!/usr/bin/env bash

function send_notification() {
  dunstify -a "waybarctl" -u low  -r 617 -h int:value:$1 "${1}%" -t 1500
}


volume=$(pamixer --get-volume)

case $1 in
  up)
    pamixer -u
    if (( volume < 125 )); then
      pamixer -i 5 --allow-boost
    fi
    send_notification $volume
    ;;
  down)
    pamixer -u
    pamixer -d 5 --allow-boost
    send_notification $volume
    ;;
  mute)
    pamixer -t
    if $(pamixer --get-mute); then
      dunstify -a "changevolume" -u low  -r 617 -h int:value:"$volume" "Muted" -t 2000
    else
      send_notification
    fi
    ;;
esac