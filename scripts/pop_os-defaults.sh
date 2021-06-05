#!/usr/bin/env bash

main () {

	dead_canary=0

	pkill -f xfce4-panel >/dev/null 2>&1
	pkill -f nm-applet >/dev/null 2>&1

	# xfconf-query -c xfce4-panel -lv > ./xfce4-panel.backup
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

	width=$(xdpyinfo | awk '/dimensions/{sub(/x.*/,""); print $2}')
	mkdir -p $HOME/Pictures/wallpapers
	cp -a ./assets/wallpapers/. $HOME/Pictures/wallpapers/
	# Credit Andy Holmes
	# Unsplash license for reuse
	# https://unsplash.com/photos/rCbdp8VCYhQ

	# gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/pop/kate-hazen-pop-m3lvin.png'
	gsettings set org.gnome.desktop.background picture-uri "file://$HOME/Pictures/wallpapers/sorunme-1920x1200.jpg"

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

	sudo apt install $apt_quite -y xfce4-notifyd xfce4-whiskermenu-plugin xfce4-power-manager xfce4-appmenu-plugin vala-panel-appmenu-common appmenu-gtk2-module appmenu-gtk3-module appmenu-gtk-module-common
	xfconf-query -c xsettings -p /Gtk/Modules -n -t string -s "appmenu-gtk-module"

	# Remove panel 2 - arrays start at 0, hence 2 = 1
	xfconf-query -c xfce4-panel -p /panels -t int -s 1 -a
	xfconf-query -c xfce4-panel -p /panels/panel-2 -rR
	# Remove applications menu
	xfconf-query -c xfce4-panel -p /panels/panel-1/plugins/plugin-1 -rR
	# Remove all plugins really
	xfconf-query -c xfce4-panel -p /panels/panel-1/plugins -rR

	# Import the good xfce4 settings
	while read line
	do
		xfconf-query -c xfce4-panel -p "$(echo $line | awk '{print $1}')" -s "$(echo $line | awk '{print $2}')" -n
	done < ./assets/xfce4/xfce4-panel.config

	gnome-extensions disable ubuntu-appindicators@ubuntu.com

	sudo cp ./assets/icons/128x128/sorunme.png /usr/share/icons/hicolor/128x128/apps/sorunme.png
	sudo cp ./assets/icons/16x16/sorunme.png /usr/share/icons/hicolor/16x16/apps/sorunme.png
	sudo cp ./assets/icons/22x22/sorunme.png /usr/share/icons/hicolor/22x22/apps/sorunme.png
	sudo cp ./assets/icons/24x24/sorunme.png /usr/share/icons/hicolor/24x24/apps/sorunme.png
	sudo cp ./assets/icons/256x256/sorunme.png /usr/share/icons/hicolor/256x256/apps/sorunme.png
	sudo cp ./assets/icons/32x32/sorunme.png /usr/share/icons/hicolor/32x32/apps/sorunme.png
	sudo cp ./assets/icons/48x48/sorunme.png /usr/share/icons/hicolor/48x48/apps/sorunme.png
	sudo cp ./assets/icons/64x64/sorunme.png /usr/share/icons/hicolor/64x64/apps/sorunme.png
	sudo cp ./assets/icons/scalable/sorunme.svg /usr/share/icons/hicolor/scalable/apps/sorunme.svg
	sudo cp ./assets/icons/scalable/sorunme.svg /usr/share/icons/McMojave-circle/apps/scalable/sorunme.svg

	cp ./assets/Pop_OS/gtk.css ~/.config/gtk-3.0/gtk.css
	mkdir -p ~/.icons
	cp -a ./assets/icons/. ~/.icons/
	ln -s ~/.icons/scalable/sorunme.svg ~/.icons/sorunme.svg
	cp -a ./assets/xfce4/. ~/.config/xfce4/
	cp -a ./assets/plank/. ~/.config/plank/
	cp -a ./assets/autostart_xfce4/. ~/.config/autostart/
	ln -s /usr/share/applications/plank.desktop ~/.config/autostart/plank.desktop
	echo "May ask you for your password to add Sorunme to your system applications."
	sudo cp -a ./assets/applications_xfce4/. /usr/share/applications/

	echo -e "Please be patient. Do not freakout, GnomeShell will come back normally...\nRestarting now to apply gnome extensions."
	dbus-send --type=method_call --print-reply --dest=org.gnome.Shell /org/gnome/Shell org.gnome.Shell.Eval string:'global.reexec_self()'

	echo "Starting xfce4-panel..."
	nohup xfce4-panel&
	sleep 10
	xdotool search --name "Whisker Menu" set_window --name " "
	nm-applet --indicator&
	echo "Killing xfce4-panel..."
	pkill -f xfce4-panel >/dev/null 2>&1
	echo "Re-copying the proper config in place for xfce4-panel..."
	cp -a ./assets/xfce4/. ~/.config/xfce4/
	sleep 1
	# Remove panel 2 - arrays start at 0, hence 2 = 1
	xfconf-query -c xfce4-panel -p /panels -t int -s 1 -a
	xfconf-query -c xfce4-panel -p /panels/panel-2 -rR
	# Remove applications menu
	xfconf-query -c xfce4-panel -p /panels/panel-1/plugins/plugin-1 -rR
	# Remove all plugins really
	xfconf-query -c xfce4-panel -p /panels/panel-1/plugins -rR
	sleep 2
	echo "Restarting xfce4-panel..."
	nohup xfce4-panel&
	nohup plank&
	echo -e "You may need to log off and back on before seeing the global menu...\n"
	question='Cmd-Space - type logout or say hit Enter to logout now.'
	choices=(*yes no)
	response=$(prompt "$question" $choices)
	if [ "$response" == "y" ];then
		gnome-session-quit
	fi

}

source ./functions/colors.sh
source ./functions/prompt.sh

main "$@"