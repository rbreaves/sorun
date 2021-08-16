#!/usr/bin/env bash

main () {
	# defaults being set elsewhere
	# gsettings set com.solus-project.budgie-panel dark-theme true

	# DE types budgie|gnome|KDE|KDE|unity|xfce|cinnamon|mate|lxde|sugar|unknown

	# Debian/Ubunutu/Pop!_OS
	if [ "$distro" == "debian" ]  || [ "$distro" == "ubuntu" ]  || [ "$distro" == "pop!_os" ];then
		mojaveQuery=`dpkg-query -l | grep "mojave\|fonts\-roboto" | wc -l`
		if [ $mojaveQuery -lt 4 ]; then
			sudo timeout 60 sudo add-apt-repository --yes ppa:ubuntubudgie/backports
			sudo DEBIAN_FRONTEND=noninteractive apt-get update < /dev/null > /dev/null
			sudo DEBIAN_FRONTEND=noninteractive apt-get $apt_quiet -y install mojave-gtk-theme mcmojave-circle fonts-roboto < /dev/null > /dev/null
		else
			echo "Already installed mojave ppa:ubuntubudgie/backports. Skipping."
		fi
	fi

	# Budgie Only
	if [ "$dename" == "budgie" ];then
		gsettings set com.solus-project.budgie-wm button-style 'left'
		gsettings set com.solus-project.budgie-panel dark-theme true
		gsettings set com.solus-project.budgie-panel layout 'cupertino'
		gsettings set com.solus-project.budgie-panel builtin-theme false
	# Gnome Only
	elif [ "$dename" == "gnome" ];then
		echo ""
	fi

	# Budgie/Gnome
	if [ "$dename" == "budgie" ] || [ "$dename" == "gnome" ];then
		gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'
		gsettings set org.gnome.desktop.wm.preferences theme "Mojave-dark"

		gsettings set org.gnome.desktop.interface cursor-theme "DMZ-Black"
		gsettings set org.gnome.desktop.interface gtk-theme "Mojave-dark"
		gsettings set org.gnome.desktop.interface icon-theme "McMojave-circle-dark"
		gsettings set org.gnome.desktop.interface monospace-font-name "Ubuntu Mono 13"
		gsettings set org.gnome.desktop.interface font-name "Roboto Regular 11"
		gsettings set org.gnome.desktop.interface document-font-name "Roboto Regular 11"

		gsettings set org.gnome.desktop.wm.preferences titlebar-font "Roboto Regular 11"
		gsettings set org.gnome.desktop.wm.preferences theme "Mojave-dark"
		gsettings set org.nemo.desktop font "Roboto Regular 11"

		gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ icon-size "72"
		gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ zoom-enabled "false"
		gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ theme 'Transparent'
		gsettings set io.elementary.desktop.wingpanel.applications-menu enable-powerstrip "true"
	fi

	sudo mv /usr/share/icons/McMojave-circle/apps/scalable/file-manager.svg /usr/share/icons/McMojave-circle/apps/scalable/file-manager.svg.bak
	sudo mv /usr/share/icons/McMojave-circle/apps/scalable/filerunner.svg /usr/share/icons/McMojave-circle/apps/scalable/filerunner.svg.bak
	sudo mv /usr/share/icons/McMojave-circle/apps/scalable/file-system-manager.svg /usr/share/icons/McMojave-circle/apps/scalable/file-system-manager.svg.bak
	sudo mv /usr/share/icons/McMojave-circle/apps/scalable/fma-config-tool.svg /usr/share/icons/McMojave-circle/apps/scalable/fma-config-tool.svg.bak
	sudo mv /usr/share/icons/McMojave-circle/apps/scalable/redhat-filemanager.svg /usr/share/icons/McMojave-circle/apps/scalable/redhat-filemanager.svg.bak
	sudo mv /usr/share/icons/McMojave-circle/apps/scalable/spacefm.svg /usr/share/icons/McMojave-circle/apps/scalable/spacefm.svg.bak
	sudo mv /usr/share/icons/McMojave-circle/apps/scalable/thunar-filemanager.svg /usr/share/icons/McMojave-circle/apps/scalable/thunar-filemanager.svg.bak
	sudo mv /usr/share/icons/McMojave-circle/apps/scalable/thunar.svg /usr/share/icons/McMojave-circle/apps/scalable/thunar.svg.bak
	sudo mv /usr/share/icons/McMojave-circle/apps/scalable/Thunar.svg /usr/share/icons/McMojave-circle/apps/scalable/Thunar.svg.bak
	sudo mv /usr/share/icons/McMojave-circle/apps/scalable/WorkerIcon48.svg /usr/share/icons/McMojave-circle/apps/scalable/WorkerIcon48.svg.bak
	sudo mv /usr/share/icons/McMojave-circle/apps/scalable/xfce-filemanager.svg /usr/share/icons/McMojave-circle/apps/scalable/xfce-filemanager.svg.bak
	sudo mv /usr/share/icons/McMojave-circle/apps/scalable/caja-actions.svg /usr/share/icons/McMojave-circle/apps/scalable/caja-actions.svg.bak
	sudo ln -s /usr/share/icons/McMojave-circle/places/scalable/blue-user-home.svg /usr/share/icons/McMojave-circle/apps/scalable/file-manager.svg
	sudo ln -s /usr/share/icons/McMojave-circle/places/scalable/blue-user-home.svg /usr/share/icons/McMojave-circle/apps/scalable/filerunner.svg
	sudo ln -s /usr/share/icons/McMojave-circle/places/scalable/blue-user-home.svg /usr/share/icons/McMojave-circle/apps/scalable/file-system-manager.svg
	sudo ln -s /usr/share/icons/McMojave-circle/places/scalable/blue-user-home.svg /usr/share/icons/McMojave-circle/apps/scalable/fma-config-tool.svg
	sudo ln -s /usr/share/icons/McMojave-circle/places/scalable/blue-user-home.svg /usr/share/icons/McMojave-circle/apps/scalable/redhat-filemanager.svg
	sudo ln -s /usr/share/icons/McMojave-circle/places/scalable/blue-user-home.svg /usr/share/icons/McMojave-circle/apps/scalable/spacefm.svg
	sudo ln -s /usr/share/icons/McMojave-circle/places/scalable/blue-user-home.svg /usr/share/icons/McMojave-circle/apps/scalable/thunar-filemanager.svg
	sudo ln -s /usr/share/icons/McMojave-circle/places/scalable/blue-user-home.svg /usr/share/icons/McMojave-circle/apps/scalable/thunar.svg
	sudo ln -s /usr/share/icons/McMojave-circle/places/scalable/blue-user-home.svg /usr/share/icons/McMojave-circle/apps/scalable/Thunar.svg
	sudo ln -s /usr/share/icons/McMojave-circle/places/scalable/blue-user-home.svg /usr/share/icons/McMojave-circle/apps/scalable/WorkerIcon48.svg
	sudo ln -s /usr/share/icons/McMojave-circle/places/scalable/blue-user-home.svg /usr/share/icons/McMojave-circle/apps/scalable/xfce-filemanager.svg
	sudo ln -s /usr/share/icons/McMojave-circle/places/scalable/blue-user-home.svg /usr/share/icons/McMojave-circle/apps/scalable/caja-actions.svg
}

source ./functions/colors.sh
source ./functions/prompt.sh

main "$@"