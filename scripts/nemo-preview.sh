#!/usr/bin/env bash

if ! dpkg-query -l | grep nemo-preview &> /dev/null;then
	sudo add-apt-repository --yes ppa:savoury1/xapps
	sudo apt-get update
	sudo apt-get install gir1.2-gtksource-4 xreader 
	# evince?

	curl -L -o /tmp/nemo-extensions.tar.gz https://github.com/linuxmint/nemo-extensions/releases/download/master.mint20/packages.tar.gz
	tar -xvzf /tmp/nemo-extensions.tar.gz
	mv /tmp/packages /tmp/nemo-extensions
	# mkdir -p /tmp/nemo-extensions
	# tar -xf /tmp/nemo-extensions.tar.gz -C /tmp/nemo-extensions
	# sudo dpkg -i /tmp/nemo-extensions/packages/nemo-preview_4.8.0_amd64.deb
	sudo apt-get install /tmp/nemo-extensions/nemo-preview_4.8.0_amd64.deb
else
	echo "Nemo-preview already installed. Skipping."
fi