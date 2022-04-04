#!/usr/bin/env bash

maxdesktops=$(gsettings get org.gnome.desktop.wm.preferences num-workspaces)
curdesktop=$(xprop -root -notype _NET_CURRENT_DESKTOP | awk '{ print $NF }')

if !( [[ $curdesktop -eq 0 ]] && [[ $1 -eq -1 ]] ) && !( [[ $curdesktop -eq $maxdesktops-1 ]] && [[ $1 -eq 1 ]] ); then
        xdotool set_desktop --relative -- $1
fi
