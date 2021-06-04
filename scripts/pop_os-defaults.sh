#!/usr/bin/env bash

main () {

	dead_canary=0

	mkdir -p ~/Documents/git-projects
	cd ~/Documents/git-projects
	if [ "$dename" == "gnome" ];then
		if ! [ -d ~/Documents/git-projects/gnome-shell-extension-installer ];then
			echo -e "Cloning gnome-shell-extension-installer..."
			git clone https://github.com/brunelli/gnome-shell-extension-installer.git
			chmod +x ./gnome-shell-extension-installer/gnome-shell-extension-installer
			echo -e "Will require sudo password to copy app to /usr/bin/"
			sudo cp ./gnome-shell-extension-installer/gnome-shell-extension-installer /usr/bin/
		else
			echo -e "GNOME Shell Extension Installer repo already exists."
		fi
	fi

	# Just Perfection
	gnome-shell-extension-installer 3843
	# Workspace Grid
	gnome-shell-extension-installer 1485

	# /org/gnome/shell/extensions/just-perfection/panel true
	echo -e "Please be patient. Do not freakout, GnomeShell will come back normally...\nRestarting now to apply gnome extensions."
	dbus-send --type=method_call --print-reply --dest=org.gnome.Shell /org/gnome/Shell org.gnome.Shell.Eval string:'global.reexec_self()'
	
	# Set horizontal workspaces
	gsettings --schemadir ~/.local/share/gnome-shell/extensions/wsmatrix@martin.zurowietz.de/schemas/ set org.gnome.shell.extensions.wsmatrix-settings num-columns 2
	gsettings --schemadir ~/.local/share/gnome-shell/extensions/wsmatrix@martin.zurowietz.de/schemas/ set org.gnome.shell.extensions.wsmatrix-settings num-rows 1

	# Hide top bar
	gsettings --schemadir ~/.local/share/gnome-shell/extensions/just-perfection-desktop@just-perfection/schemas/ set org.gnome.shell.extensions.just-perfection panel false

	

	# question="Ask generic question?"
	# choices=(*yes no)
	# response=$(prompt "$question" $choices)
	# if [ "$response" == "y" ];then
	# 	echo ""
	# else
	# 	echo ""
	# fi

	# success="This ran successfully!"
	# failure="This failed! :/"
	# test
	# canary $? "$success" "$failure"
	# dead_canary=$((($(echo $?)==1) ? 1 : $dead_canary ))

}

source ./functions/colors.sh
source ./functions/prompt.sh

main "$@"