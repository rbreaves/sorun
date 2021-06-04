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

	gsettings get org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/pop/kate-hazen-pop-m3lvin.png'

	# Just Perfection
	gnome-shell-extension-installer 3843
	# Workspace Grid
	gnome-shell-extension-installer 1485

	
	# Set horizontal workspaces
	gsettings --schemadir ~/.local/share/gnome-shell/extensions/wsmatrix@martin.zurowietz.de/schemas/ set org.gnome.shell.extensions.wsmatrix-settings num-columns 2
	gsettings --schemadir ~/.local/share/gnome-shell/extensions/wsmatrix@martin.zurowietz.de/schemas/ set org.gnome.shell.extensions.wsmatrix-settings num-rows 1

	# Hide top bar
	gsettings --schemadir ~/.local/share/gnome-shell/extensions/just-perfection-desktop@just-perfection/schemas/ set org.gnome.shell.extensions.just-perfection panel false
	gsettings --schemadir ~/.local/share/gnome-shell/extensions/just-perfection-desktop@just-perfection/schemas/ set org.gnome.shell.extensions.just-perfection dash false

	sudo apt install xfce4-notifyd xfce4-whiskermenu-plugin xfce4-power-manager xfce4-appmenu-plugin vala-panel-appmenu-common appmenu-gtk2-module appmenu-gtk3-module appmenu-gtk-module-common
	xfconf-query -c xsettings -p /Gtk/Modules -n -t string -s "appmenu-gtk-module"

	gnome-extensions disable ubuntu-appindicators@ubuntu.com

	sudo cp ./assets/whiskermenu/128x128_kairos.png /usr/share/icons/hicolor/128x128/apps/128x128_kairos.png
	sudo cp ./assets/whiskermenu/16x16_kairos.png /usr/share/icons/hicolor/16x16/apps/16x16_kairos.png
	sudo cp ./assets/whiskermenu/22x22_kairos.png /usr/share/icons/hicolor/22x22/apps/22x22_kairos.png
	sudo cp ./assets/whiskermenu/24x24_kairos.png /usr/share/icons/hicolor/24x24/apps/24x24_kairos.png
	sudo cp ./assets/whiskermenu/256x256_kairos.png /usr/share/icons/hicolor/256x256/apps/256x256_kairos.png
	sudo cp ./assets/whiskermenu/32x32_kairos.png /usr/share/icons/hicolor/32x32/apps/32x32_kairos.png
	sudo cp ./assets/whiskermenu/48x48_kairos.png /usr/share/icons/hicolor/48x48/apps/48x48_kairos.png
	sudo cp ./assets/whiskermenu/64x64_kairos.png /usr/share/icons/hicolor/64x64/apps/64x64_kairos.png
	sudo cp ./assets/whiskermenu/scalable_kairos.svg /usr/share/icons/hicolor/scalable/apps/scalable_kairos.svg

	cp ./assets/Pop_OS/gtk.css ~/.config/gtk-3.0/gtk.css
	cp -a ./assets/xfce4/. ~/.config/xfce4/

	echo -e "Please be patient. Do not freakout, GnomeShell will come back normally...\nRestarting now to apply gnome extensions."
	dbus-send --type=method_call --print-reply --dest=org.gnome.Shell /org/gnome/Shell org.gnome.Shell.Eval string:'global.reexec_self()'
	
	nohup xfce4-panel&
	sleep 2
	xdotool search --name "Whisker Menu" set_window --name " "
	nm-applet --indicator&

}

source ./functions/colors.sh
source ./functions/prompt.sh

main "$@"