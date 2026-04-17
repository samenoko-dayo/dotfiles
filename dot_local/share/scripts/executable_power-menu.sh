#!/bin/bash

# 選択肢の定義
options="󰐥 Shutdown\n󰜉 Reboot\n󰤄 Suspend\n󰈆 Logout\n Lock"

# Walkerをdmenuモードで起動
choice=$(echo -e "$options" | walker --dmenu -p "Power:")

# 選択結果に応じた処理
case "$choice" in
    *Shutdown)
        systemctl poweroff
        ;;
    *Reboot)
        systemctl reboot
        ;;
    *Suspend)
        systemctl suspend
        ;;
    *Logout)
        # 環境に合わせて変更（Hyprlandなら hyprctl dispatch exit など）
        loginctl terminate-user $USER
        ;;
    *Lock)
        # 環境に合わせて変更（hyprlock, swaylock, swaylock-effectsなど）
        hyprlock
        ;;
esac