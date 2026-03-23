#!/bin/bash

choice=$(printf "Off\nReboot\nExit" | rofi -dmenu -theme selector.rasi -theme-str 'listview { lines: 3; }' )

case "$choice" in
  "Off ") systemctl poweroff ;;
  "Reboot") systemctl reboot ;;
  "Exit") hyprctl dispatch exit ;;
esac