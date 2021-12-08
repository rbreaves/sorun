#!/usr/bin/env bash

if ! command -v albert &> /dev/null; then
	# Need to detect Ubuntu version and then install the correct repo
	curl https://build.opensuse.org/projects/home:manuelschneid3r/public_key | sudo apt-key add -
	echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_21.10/ /' | sudo tee /etc/apt/sources.list.d/home:manuelschneid3r.list
	sudo wget -nv https://download.opensuse.org/repositories/home:manuelschneid3r/xUbuntu_21.10/Release.key -O "/etc/apt/trusted.gpg.d/home:manuelschneid3r.asc"
else
	echo "Detected Albert as being installed. Skipping repo addition."
fi
