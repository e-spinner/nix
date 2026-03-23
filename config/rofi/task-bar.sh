#!/bin/bash

choice=$(printf "Firefox\0icon\x1ffirefox\nVS Code\0icon\x1fcom.visualstudio.code.oss\nKitty\0icon\x1fkitty\nThunar\0icon\x1forg.xfce.thunar\nObsidian\0icon\x1fobsidian\nLite XL\0icon\x1flite-xl\nSpotify\0icon\x1fspotify-launcher\n" | rofi -dmenu -show-icons -theme task-bar.rasi -theme-str 'listview { lines: 7; }' )

case "$choice" in
  Firefox)    firefox & ;;
  "VS Code")  code & ;;
  Kitty)      kitty & ;;
  Thunar)     thunar & ;;
  Obsidian)   obsidian & ;;
  "Lite XL")  lite-xl & ;;
  Spotify)    spotify-launcher & ;;
esac