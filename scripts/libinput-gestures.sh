#!/usr/bin/env bash

sudo gpasswd -a $USER input

cd /tmp
git clone http://github.com/bulletmark/libinput-gestures
cd ./libinput-gestures
sudo make install

cp /etc/libinput-gestures.conf ~/.config/libinput-gestures.conf

sed -i "s/gesture swipe up  _internal ws_up/gesture swipe left 3    xdotool set_desktop --relative -- -1/g" ~/.config/libinput-gestures.conf
sed -i "s/gesture swipe down	_internal ws_down/gesture swipe right 3    xdotool set_desktop --relative 1/g" ~/.config/libinput-gestures.conf

libinput-gestures-setup start
libinput-gestures-setup autostart
libinput-gestures-setup status

echo "May need to logoff and back on for 3 finger left and right gestures to work for virtual desktops."
echo ""
echo "Installing Gestures app gives a GUI interface for gestures. May be commented out in Kairos."
echo "https://gitlab.com/cunidev/gestures"
echo ""