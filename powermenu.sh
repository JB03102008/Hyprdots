#!/usr/bin/env bash

main_dir="$HOME/.config/rofi"
dir="$main_dir/themes"
theme="rofi-powertheme"

uptime="$(awk '{printf "%d hour(s), %d minute(s)\n", $1/3600, ($1%3600)/60}' /proc/uptime)"

shutdown='  Shutdown'
reboot='  Reboot'
lock='  Lock'
suspend='  Suspend'
logout='  Logout'
yes=''
no=''

rofi_cmd() {
    rofi -dmenu \
        -p "Goodbye ${USER}" \
        -mesg "Uptime: $uptime" \
        -theme "${dir}/${theme}.rasi"
}

confirm_cmd() {
    rofi -dmenu \
        -p "Confirm" \
        -mesg "Are you sure?" \
        -theme "${main_dir}/rofi-confirm.rasi"
}

confirm() {
    echo -e "$yes\n$no" | confirm_cmd
}

menu() {
    echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

chosen="$(menu)"

case "$chosen" in
    "$lock")
	hyprlock
        ;;
    "$logout")
	[[ "$(confirm)" == "$yes" ]] && hyprctl dispatch exit
        ;;
    "$suspend")
        [[ "$(confirm)" == "$yes" ]] && systemctl suspend
        ;;
    "$reboot")
	[[ "$(confirm)" == "$yes" ]] && systemctl reboot
        ;;
    "$shutdown")
        [[ "$(confirm)" == "$yes" ]] && systemctl poweroff
        ;;
esac
