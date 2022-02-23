#!/usr/bin/env bash

if ! command -v anydesk &> /dev/null; then
    wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
	sudo DEBIAN_FRONTEND=noninteractive apt-get $apt_quiet -y install apt-transport-https < /dev/null > /dev/null
	echo "deb http://deb.anydesk.com/ all main" | sudo tee '/etc/apt/sources.list.d/anydesk-stable.list'
else
	echo "Detected Anydesk as being installed. Skipping repo addition."
fi