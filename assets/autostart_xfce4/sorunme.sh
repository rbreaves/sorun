#!/usr/bin/env bash

/usr/bin/pkill -9 /usr/bin/nm-applet
/usr/bin/nohup /usr/bin/nm-applet --indicator &
/usr/bin/pkill -9 /usr/bin/xfce4-panel
/usr/bin/nohup xfce4-panel &
/usr/bin/sleep 2
for run in {1..3};do
	/usr/bin/xdotool search --name "Whisker Menu" set_window --name " "
	/usr/bin/sleep 0.1
done