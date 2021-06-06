#!/usr/bin/env bash

if ! command -v nemo-preview &> /dev/null; then
	# fixes bug in 21.04 beta of Pop!_OS
	if [ -f /usr/share/distro-info/pop.csv ] && [ "$distro" == "pop!_os" ];then
		sudo cp /usr/share/distro-info/ubuntu.csv /usr/share/distro-info/pop.csv
	fi
	sudo timeout 60 sudo DEBIAN_FRONTEND=noninteractive add-apt-repository --yes ppa:ubuntubudgie/backports < /dev/null > /dev/null
else
	echo "Detected nemo-preview as being installed. Skipping repo addition."
fi