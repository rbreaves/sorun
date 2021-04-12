#!/usr/bin/env bash

if ! command -v code &> /dev/null; then
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	sudo apt-get -y install apt-transport-https
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
else
	echo "Detected Sublime-text 3 as being installed. Skipping repo addition."
fi