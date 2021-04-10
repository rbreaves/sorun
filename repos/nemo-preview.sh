#!/usr/bin/env bash

if ! command -v nemo-preview &> /dev/null; then
	sudo add-apt-repository --yes ppa:ubuntubudgie/backports
else
	echo "Detected nemo-preview as being installed. Skipping repo addition."
fi