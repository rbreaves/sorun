#!/usr/bin/env bash

main () {

	dead_canary=0

	# Set nemo as default file manager
	xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
	gsettings set org.gnome.desktop.background show-desktop-icons false
	gsettings set org.nemo.desktop show-desktop-icons true

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

	release=$(lsb_release -sr)
	if [ "$release" == "21.04" ];then
		prior_extensions=$(gsettings get org.gnome.shell enabled-extensions)
		echo "Prior extensions enabled: $prior_extensions"
		echo -e "\n Will be setting back to defaults plus Just Perfection and wsmatrix."
		gsettings set org.gnome.shell enabled-extensions ['ding@rastersoft.com', 'multi-monitors-add-on@spin83', 'pop-cosmic@system76.com', 'pop-shell@system76.com', 'system76-power@system76.com', 'ubuntu-dock@ubuntu.com', 'just-perfection-desktop@just-perfection', 'wsmatrix@martin.zurowietz.de']
	fi

	sudo DEBIAN_FRONTEND=noninteractive apt-get install $apt_quite -y gir1.2-appindicator3-0.1 xfce4-statusnotifier-plugin xfce4-notifyd xfce4-whiskermenu-plugin xfce4-power-manager xfce4-appmenu-plugin vala-panel-appmenu-common appmenu-gtk2-module appmenu-gtk3-module appmenu-gtk-module-common < /dev/null > /dev/null

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
	# While this copies needed settings - the copy to system level folders is what really fixes it
	cp -a ./assets/xfce4/. ~/.config/xfce4/
	# Not really needed for panel file as it will go elsewhere in a moment
	sudo cp -a ./assets/xfce4/. /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/
	# Covers the default xfce4-panel config
	sudo cp /etc/xdg/xfce4/panel/default.xml /etc/xdg/xfce4/panel/default.xml.bak
	sudo cp -a ./assets/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml /etc/xdg/xfce4/panel/default.xml
	mv ~/.config/plank ~/.config/plank.bak
	cp -a ./assets/plank/. ~/.config/plank/
	cp -a ./assets/autostart_xfce4/. ~/.config/autostart/
	ln -s /usr/share/applications/plank.desktop ~/.config/autostart/plank.desktop
	echo "May ask you for your password to add Sorunme to your system applications."
	sudo cp -a ./assets/applications_xfce4/. /usr/share/applications/

	echo -e "Please be patient. Do not freakout, GnomeShell will come back normally...\nRestarting now to apply gnome extensions.\n"
	dbus-send --type=method_call --print-reply --dest=org.gnome.Shell /org/gnome/Shell org.gnome.Shell.Eval string:'global.reexec_self()'

	sleep 5
	echo "Starting xfce4-panel..."
	nohup xfce4-panel&
	nohip nm-applet --indicator&
	nohup plank&

	echo -e "Your terminals global menu will appear when you re-open it.\nThe workspaces plugin will set itself right once you log off and back on."

}

source ./functions/colors.sh
source ./functions/prompt.sh

main "$@"