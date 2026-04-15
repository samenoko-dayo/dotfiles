#!/bin/bash
HUE=$(cat /tmp/matugen_hue)

if [ -z $HUE ]; then
    exit 1
fi

case $HUE in
    [0-9]|1[0-9]|3[5-6][0-9]) COL="red" ;;
    2[0-9]|3[0-9]|4[4-9])     COL="orange" ;;
    4[5-9]|5[0-9]|6[0-9])     COL="yellow" ;;
    7[0-9]|[8-9][0-9]|1[4-5][0-9]) COL="green" ;;
    1[6-9][0-9]|2[4-9][0-9])  COL="blue" ;;
    2[5-9][0-9]|2[9][0-9])    COL="purple" ;;
    3[0-4][0-9])              COL="pink" ;;
    *)                        COL="standard" ;;
esac

if [ "$COL" = "standard" ]; then
    ICON_THEME="Tela-circle"
else
    ICON_THEME="Tela-circle-$COL"
fi

echo "Net/IconThemeName \"$ICON_THEME\"" | tee ~/.xsettingsd >/dev/null
killall -HUP xsettingsd
gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"