#!/usr/bin/env bash

if ! command -v uget &> /dev/null; then
	sudo timeout 60 sudo DEBIAN_FRONTEND=noninteractive add-apt-repository --yes ppa:uget-team/ppa < /dev/null > /dev/null
else
	echo "Detected uget as being installed. Skipping repo addition."
fi