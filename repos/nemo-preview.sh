#!/usr/bin/env bash

if ! command -v nemo-preview &> /dev/null; then
	sudo timeout 60 sudo DEBIAN_FRONTEND=noninteractive add-apt-repository --yes ppa:ubuntubudgie/backports < /dev/null > /dev/null
else
	echo "Detected nemo-preview as being installed. Skipping repo addition."
fi