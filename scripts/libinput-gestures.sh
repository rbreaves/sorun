#!/usr/bin/env bash

sudo gpasswd -a $USER input

cd $HOME
git clone http://github.com/bulletmark/libinput-gestures
cd ./libinput-gestures
sudo make install

cp /etc/libinput-gestures.conf ~/.config/libinput-gestures.conf

# TODO
# Add in sed commands to configure gestures

# gesture swipe up   _internal ws_up / gesture swipe left 3   _internal ws_up
# gesture swipe down    _internal ws_down / gesture swipe right 3    _internal ws_down

# Add another prompt at the end of the install to remind users to log off and back on for libinput gestures